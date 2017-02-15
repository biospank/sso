defmodule Sso.User.SessionControllerTest do
  use Sso.ConnCase

  @valid_attrs %{
    email: "test@example.com",
    password: "secret",
  }

  setup %{conn: conn} do
    organization = insert_organization()
    account = insert_account(organization)

    {:ok, jwt, full_claims} = Guardian.encode_and_sign(account)

    conn = conn
      |> put_req_header("authorization", "Dardy #{jwt}")
      |> put_req_header("accept", "application/vnd.dardy.sso.v1+json")

    {:ok, conn: conn, account: account, jwt: jwt, claims: full_claims}
  end

  describe "login user" do
    setup %{conn: conn, account: account} do
      insert_user(account, %{active: true, status: :verified})

      {:ok, conn: conn}
    end

    test "with valid credentials", %{conn: conn} do
      conn = post(
        conn,
        user_session_path(conn, :create),
        user: @valid_attrs
      )
      assert json_response(conn, 201)["user"]["id"]
    end

    test "with invalid email", %{conn: conn} do
      conn = post(
        conn,
        user_session_path(conn, :create),
        user: Map.put(@valid_attrs, :email, "invalid@email.com")
      )
      assert json_response(conn, 404)["errors"] == %{
        "detail" => "user not found"
      }
    end

    test "with invalid password", %{conn: conn} do
      conn = post(
        conn,
        user_session_path(conn, :create),
        user: Map.put(@valid_attrs, :password, "invalid-password")
      )
      assert json_response(conn, 401)["errors"] == %{
        "detail" => "user unauthorized"
      }
    end
  end

  describe "login existing user" do
    setup %{conn: conn} do
      organization = insert_organization(%{name: "new name"})
      new_account = insert_account(
        organization,
        %{
          app_name: "new app name"
        }
      )

      insert_user(new_account, %{
        email: "newuser@example.com",
        active: true,
        status: :verified
      })

      {:ok, conn: conn}
    end

    test "from different organization", %{conn: conn} do
      conn = post(
        conn,
        user_session_path(conn, :create),
        user: @valid_attrs
      )

      assert json_response(conn, 404)["errors"] == %{
        "detail" => "user not found"
      }

    end
  end

  describe "disabled user" do
    setup %{conn: conn, account: account} do
      insert_user(account, %{active: false})

      {:ok, conn: conn}
    end

    test "returns 423", %{conn: conn} do
      post_conn = post(
        conn,
        user_session_path(conn, :create),
        user: @valid_attrs
      )
      assert json_response(post_conn, 423)["errors"] == %{
        "detail" => "user temporary disabled"
      }
    end
  end

  describe "unverified user" do
    setup %{conn: conn, account: account} do
      insert_user(account, %{active: true, status: :unverified})

      {:ok, conn: conn}
    end

    test "returns 451", %{conn: conn} do
      post_conn = post(
        conn,
        user_session_path(conn, :create),
        user: @valid_attrs
      )
      assert json_response(post_conn, 451)["errors"] == %{
        "detail" => "user not verified"
      }
    end
  end

  describe "logged in user" do
    setup %{conn: conn, account: account} do
      user = insert_user(account)

      {:ok, conn: conn, user: user}
    end

    test "logout", %{conn: conn, user: user} do
      conn = delete conn, user_session_path(conn, :delete, user)
      assert response(conn, 204)
    end
  end
end
