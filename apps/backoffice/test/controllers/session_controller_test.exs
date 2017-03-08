defmodule Backoffice.SessionControllerTest do
  use Backoffice.ConnCase

  @valid_attrs %{
    username: "admin",
    password: "secret",
  }

  setup %{conn: conn} do
    insert_bo_user()

    conn = put_req_header(conn, "accept", "application/json")

    {:ok, conn: conn}
  end

  describe "login user" do
    test "with valid credentials", %{conn: conn} do
      conn = post(
        conn,
        session_path(conn, :create),
        user: @valid_attrs
      )
      assert json_response(conn, 201)["user"]["id"]
    end

    test "with invalid username", %{conn: conn} do
      conn = post(
        conn,
        session_path(conn, :create),
        user: Map.put(@valid_attrs, :username, "invalid-username")
      )
      assert json_response(conn, 404)["errors"] == %{
        "username" => "Nome utente non valido"
      }
    end

    test "with invalid password", %{conn: conn} do
      conn = post(
        conn,
        session_path(conn, :create),
        user: Map.put(@valid_attrs, :password, "invalid-password")
      )
      assert json_response(conn, 401)["errors"] == %{
        "password" => "Password non valida"
      }
    end
  end
end
