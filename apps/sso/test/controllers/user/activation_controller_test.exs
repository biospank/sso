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
      post_conn = put conn, user_activation_path(conn, :confirm, @invalid_activation_code)

      assert json_response(post_conn, 404)["errors"] == %{
        "detail" => "Activation code not found"
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
      assert email.subject == "Sso - Registazione utente"
      assert email.html_body =~ "Codice di attivazione: #{user.activation_code}"
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
      assert email.subject == "Sso - Registazione utente"
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
  end
end
