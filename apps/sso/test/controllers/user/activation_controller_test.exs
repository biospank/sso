defmodule Sso.User.ActivationControllerTest do
  use Sso.ConnCase
  use Bamboo.Test, shared: :true

  alias Sso.User

  setup %{conn: conn} do
    organization = insert_organization()
    account = insert_account(organization)
    user = insert_user(account)

    conn = put_req_header(conn, "accept", "application/vnd.dardy.sso.v1+json")

    {:ok, conn: conn, account: account, user: user}
  end

  describe "activation endpoint" do
    test "requires account authentication", %{conn: conn, user: user} do
      conn = put(conn, user_activation_path(conn, :confirm, user.activation_code))
      assert json_response(conn, 498)["errors"] == %{
        "detail" => "Authentication required (invalid token)"
      }
      assert conn.halted
    end
  end

  describe "activation controller" do
    @invalid_activation_code "_eoos7749wehhbbswiw883w7s"
    @invalid_email "some@content"
    @callback_url "http://anysite.com/opt-in"

    setup %{conn: conn, account: account, user: user} do
      {:ok, jwt, _} = Guardian.encode_and_sign(account)

      conn = put_req_header(conn, "authorization", "Dardy #{jwt}")

      account =
        account
        |> Repo.preload(:organization)

      {:ok, conn: conn, user: user, account: account}
    end

    test "valid activation code", %{conn: conn, user: user} do
      conn = put conn, user_activation_path(conn, :confirm, user.activation_code)
      assert json_response(conn, 200)
    end

    test "invalid activation code", %{conn: conn} do
      put_conn = put conn, user_activation_path(conn, :confirm, @invalid_activation_code)

      assert json_response(put_conn, 404)["errors"] == %{
        "detail" => "Activation code not found"
      }
    end

    test "already activated user", %{conn: conn, user: user} do
      user |> Ecto.Changeset.change(active: true) |> Repo.update!

      put_conn = put conn, user_activation_path(conn, :confirm,user.activation_code)

      assert json_response(put_conn, 304)["errors"] == %{
        "detail" => "Not Modified"
      }
    end

    test "resend activation code with valid email", %{conn: conn, user: user} do
      conn = post conn, user_resend_activation_code_path(conn, :resend), user: %{
        "email" => user.email
      }
      assert json_response(conn, 200)
    end

    test "resend activation deliver a welcome email", %{conn: conn, account: account, user: user} do
      conn = post conn, user_resend_activation_code_path(conn, :resend), user: %{
        "email" => user.email
      }
      user = Repo.get(User, json_response(conn, 200)["user"]["id"])
      assert_delivered_email Sso.Email.welcome_email(user, account, nil)
    end

    test "welcome email", %{conn: conn, account: account, user: user} do
      post(conn, user_resend_activation_code_path(conn, :resend), user: %{
        "email" => user.email
      })
      email = Sso.Email.welcome_email(user, account, nil)
      assert email.from == account
      assert email.to == user
      assert email.subject == "app name - Richiesta registrazione"
      assert email.html_body =~ "#{user.activation_code}"
    end

    test "resend activation code with callback, deliver a welcome email with callback", %{conn: conn, account: account, user: user} do
      post(conn, user_resend_activation_code_path(conn, :resend), user: %{
        "email" => user.email,
        "callback_url" => @callback_url
      })
      location = @callback_url <> "?code=#{user.activation_code}"
      assert_delivered_email Sso.Email.welcome_email(user, account, location)
    end

    test "welcome email with link", %{conn: conn, account: account, user: user} do
      post(conn, user_resend_activation_code_path(conn, :resend), user: %{
        "email" => user.email,
        "callback_url" => @callback_url
      })
      location = @callback_url <> "?code=#{user.activation_code}"
      email = Sso.Email.welcome_email(user, account, location)
      assert email.from == account
      assert email.to == user
      assert email.subject == "app name - Richiesta registrazione"
      assert email.html_body =~ location
    end

    test "resend activation code with invalid email", %{conn: conn} do
      post_conn = post conn, user_resend_activation_code_path(conn, :resend), user: %{
        "email" => @invalid_email
      }

      assert json_response(post_conn, 404)["errors"] == %{
        "detail" => "Email not found"
      }
    end

    # Il reinvio del codice di attivazione può essere effettuato
    # verso un utente appartenente alla stessa organizzazione dell'account
    # che è stato autenticato.
    # Nel test seguente l'account autenticato è nel setup mentre
    # l'utente a cui viene reinviato il codice di attivazione appartiene
    # ad un altro account (non autenticato) di un organizzazione diversa.
    test "activation code can be resent by one of the same organization's authorized account", %{conn: conn} do
      new_organization = insert_organization(%{
        name: "new name",
        ref_email: "neworg@example.com"
      })
      new_account = insert_account(new_organization, %{
        app_name: "new app name"
      })
      new_user = insert_user(new_account, %{
        email: "newuser@example.com"
      })

      post_conn = post conn, user_resend_activation_code_path(conn, :resend), user: %{
        "email" => new_user.email
      }

      assert json_response(post_conn, 404)["errors"] == %{
        "detail" => "Email not found"
      }
    end
  end
end
