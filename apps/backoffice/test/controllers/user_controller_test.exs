defmodule Backoffice.UserControllerTest do
  use Backoffice.ConnCase

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")

    {:ok, conn: conn}
  end

  describe "user endpoint" do
    test "requires user authentication", %{conn: conn} do
      conn = get(conn, user_path(conn, :index))
      assert json_response(conn, 498)["errors"] == %{
        "message" => "Authentication required (invalid token)"
      }
      assert conn.halted
    end
  end

  describe "user controller" do
    @callback_url "http://anysite.com/opt-in"

    setup %{conn: conn} do
      user = insert_bo_user()
      {:ok, jwt, _} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Dardy #{jwt}")

      {:ok, conn: conn, user: user}
    end

    test "list all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200)["users"] == []
    end
  end
end
