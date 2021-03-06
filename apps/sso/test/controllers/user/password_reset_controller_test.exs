defmodule Sso.User.PasswordResetControllerTest do
  use Sso.ConnCase
  use Bamboo.Test, shared: :true


  describe "Password reset controller endpoint" do
    setup %{conn: conn} = config do
      if config[:accept_header] do
        conn =
          conn
          |> put_req_header("accept", "application/vnd.dardy.sso.v1+json")

          {:ok, conn: conn}
      else
        {:ok, conn: conn}
      end
    end

    test "requires accept header", %{conn: conn} do
      post_conn = post conn, user_password_reset_path(conn, :create), user: %{
        email: "test@example.com"
      }

      assert post_conn.status == 406
      assert post_conn.resp_body == "Not Acceptable"
      assert post_conn.halted
    end

    @tag :accept_header
    test "requires account authentication", %{conn: conn} do
      post_conn = post conn, user_password_reset_path(conn, :create), user: %{
        email: "test@example.com"
      }

      assert json_response(post_conn, 498)["errors"] == %{
        "detail" => "Authentication required (invalid token)"
      }
      assert post_conn.halted
    end
  end

  describe "password reset request" do
    @callback_url "http://anysite.com/resetpwd"

    setup %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization) |> Repo.preload(:organization)
      user = insert_user(account)
      {:ok, jwt, _} = Guardian.encode_and_sign(account)

      conn =
        conn
        |> put_req_header("accept", "application/vnd.dardy.sso.v1+json")
        |> put_req_header("authorization", "Dardy #{jwt}")

      {:ok, conn: conn, account: account, user: user}
    end

    test "with valid email", %{conn: conn, user: user} do
      post_conn = post conn, user_password_reset_path(conn, :create), user: %{
        email: user.email
      }

      assert post_conn.status == 201
    end

    test "with invalid email", %{conn: conn} do
      post_conn = post conn, user_password_reset_path(conn, :create), user: %{
        email: "invalid-test@example.com"
      }

      assert json_response(post_conn, 404)["errors"] == %{
        "detail" => "Email not found"
      }
    end

    test "deliver a password reset email", %{conn: conn, account: account, user: user} do
      post_conn = post conn, user_password_reset_path(conn, :create), user: %{
        email: user.email
      }

      assert post_conn.status == 201
      user = Repo.get(Sso.User, user.id)

      {:ok, email} = Sso.Email.password_reset_template(user, account, nil)

      assert_delivered_email email
    end

    test "password reset email", %{conn: conn, account: account, user: user} do
      post_conn = post conn, user_password_reset_path(conn, :create), user: %{
        email: user.email
      }

      assert post_conn.status == 201
      user = Repo.get(Sso.User, user.id)
      {:ok, email} = Sso.Email.password_reset_template(user, account, nil)

      assert email.from == account
      assert email.to == user
      assert email.subject == "app name - Recupera password"
      assert email.html_body =~ "#{user.reset_code}"
    end

    test "deliver a password reset email with callback", %{conn: conn, account: account, user: user} do
      post_conn =
        conn
        |> post(
            user_password_reset_path(conn, :create),
            user: %{
              email: user.email,
              callback_url: @callback_url
            }
        )

      assert post_conn.status == 201
      user = Repo.get(Sso.User, user.id)
      location = @callback_url <> "?code=#{user.reset_code}"

      {:ok, email} = Sso.Email.password_reset_template(user, account, location)

      assert_delivered_email email
    end

    test "password reset email with link", %{conn: conn, account: account, user: user} do
      post_conn =
        conn
        |> post(
            user_password_reset_path(conn, :create),
            user: %{
              email: user.email,
              callback_url: @callback_url
            }
        )

      assert post_conn.status == 201
      user = Repo.get(Sso.User, user.id)
      location = @callback_url <> "?code=#{user.reset_code}"
      {:ok, email} = Sso.Email.password_reset_template(user, account, location)

      assert email.from == account
      assert email.to == user
      assert email.subject == "app name - Recupera password"
      assert email.html_body =~ location
    end
  end

  describe "perform password reset" do
    setup %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization)
      user = insert_user(account)
      {:ok, jwt, _} = Guardian.encode_and_sign(account)

      conn =
        conn
        |> put_req_header("accept", "application/vnd.dardy.sso.v1+json")
        |> put_req_header("authorization", "Dardy #{jwt}")

      {:ok, conn: conn, account: account, user: user}
    end

    test "with valid reset code", %{conn: conn, user: user} do
      post conn, user_password_reset_path(conn, :create), user: %{
        email: user.email
      }
      user = Repo.get(Sso.User, user.id)
      put_conn = put conn, user_password_reset_path(conn, :update, user.reset_code), user: %{
        password: "new_password",
        password_confirmation: "new_password"
      }

      assert json_response(put_conn, 200)["user"]["id"]
    end

    test "with invalid reset code", %{conn: conn, user: user} do
      post conn, user_password_reset_path(conn, :create), user: %{
        email: user.email
      }
      put_conn = put conn, user_password_reset_path(conn, :update, "invalid-reset-code"), user: %{
        password: "new_password",
        password_confirmation: "new_password"
      }

      assert json_response(put_conn, 404)["errors"] == %{
        "detail" => "Reset code not found"
      }
    end

    test "with password too short", %{conn: conn, user: user} do
      post conn, user_password_reset_path(conn, :create), user: %{
        email: user.email
      }
      user = Repo.get(Sso.User, user.id)
      put_conn = put conn, user_password_reset_path(conn, :update, user.reset_code), user: %{
        password: "pwd",
        password_confirmation: "pwd"
      }

      assert json_response(put_conn, :unprocessable_entity)["errors"] == %{
        "password" => ["should be at least 6 character(s)"]
      }
    end

    test "with unmatched password confirmation", %{conn: conn, user: user} do
      post conn, user_password_reset_path(conn, :create), user: %{
        email: user.email
      }
      user = Repo.get(Sso.User, user.id)
      put_conn = put conn, user_password_reset_path(conn, :update, user.reset_code), user: %{
        password: "new_password",
        password_confirmation: "new_pass"
      }

      assert json_response(put_conn, :unprocessable_entity)["errors"] == %{
        "password_confirmation" => ["does not match password"]
      }
    end

    # L'aggiornamento del profilo utente può essere effettuato
    # per un utente appartenente alla stessa organizzazione dell'account
    # che è stato autenticato.
    # Nel test seguente l'account autenticato è nel setup mentre
    # l'utente per cui viene aggiornato il profilo appartiene
    # ad un altro account (non autenticato) di un organizzazione diversa.
    test "profile update can be done by one of the same organization's authorized account", %{conn: conn} do
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

      put_conn = put(
        conn,
        user_profile_path(conn, :update, new_user),
        profile: %{
          phone_number: "882726109998",
        }
      )

      assert json_response(put_conn, 404)["errors"] == %{
        "detail" => "User not found"
      }
    end

    # La richiesta del reset della password può essere effettuato
    # per un utente appartenente alla stessa organizzazione dell'account
    # che è stato autenticato.
    # Nel test seguente l'account autenticato è nel setup mentre
    # l'utente per cui viene richiesto il reset della password appartiene
    # ad un altro account (non autenticato) di un organizzazione diversa.
    test "password reset request can be done by one of the same organization's authorized account", %{conn: conn} do
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

      post_conn = post conn, user_password_reset_path(conn, :create), user: %{
        email: new_user.email
      }

      assert json_response(post_conn, 404)["errors"] == %{
        "detail" => "Email not found"
      }
    end
  end
end
