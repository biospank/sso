defmodule Sso.User.PasswordChangeControllerTest do
  use Sso.ConnCase

  @valid_attrs %{
    password: "secret",
    new_password: "secret123",
    new_password_confirmation: "secret123"
  }

  describe "Password change endpoint" do
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
      put_conn = put(conn, user_password_change_path(conn, :change, 123), user: %{})

      assert put_conn.status == 406
      assert put_conn.resp_body == "Not Acceptable"
      assert put_conn.halted
    end

    @tag :accept_header
    test "requires account authentication", %{conn: conn} do
      put_conn = put(conn, user_password_change_path(conn, :change, 123), user: %{
        email: "test@example.com"
      })

      assert json_response(put_conn, 498)["errors"] == %{
        "detail" => "Authentication required (invalid token)"
      }
      assert put_conn.halted
    end
  end

  describe "Password change controller" do
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

    test "valid parameters", %{conn: conn, user: user} do
      conn = put(conn, user_password_change_path(conn, :change, user), user: @valid_attrs)
      assert json_response(conn, 200)["user"] != %{}
    end

    test "invalid parameters", %{conn: conn, user: user} do
      conn = put(conn, user_password_change_path(conn, :change, user), user: Map.merge(@valid_attrs, %{new_password: "pwd"}))
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "invalid current password", %{conn: conn, user: user} do
      conn = put(conn, user_password_change_path(conn, :change, user), user: %{password: "invalid"})
      assert json_response(conn, 422)["errors"] == %{"password" => ["not valid"]}
    end

    # La richiesta del cambio della password può essere effettuato
    # per un utente appartenente alla stessa organizzazione dell'account
    # che è stato autenticato.
    # Nel test seguente l'account autenticato è nel setup mentre
    # l'utente per cui viene richiesto il cambio della password appartiene
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

      put_conn = put conn, user_password_change_path(conn, :change, new_user), user: @valid_attrs

      assert json_response(put_conn, 404)["errors"] == %{
        "detail" => "User not found"
      }
    end
  end
end
