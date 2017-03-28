defmodule Backoffice.BoUser.PasswordControllerTest do
  use Backoffice.ConnCase

  @valid_attrs %{
    password: "secret",
    new_password: "secret123",
    new_password_confirmation: "secret123"
  }

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")

    {:ok, conn: conn}
  end

  describe "bouser password endpoint" do
    test "requires user authentication", %{conn: conn} do
      conn = put(conn, bouser_password_path(conn, :change), user: %{})
      assert json_response(conn, 498)["errors"] == %{
        "message" => "Richiesta autorizzazione (token non valido)"
      }
      assert conn.halted
    end
  end

  describe "bouser password controller" do
    setup %{conn: conn} do
      user = insert_bo_user()
      {:ok, jwt, _} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Dardy #{jwt}")

      {:ok, conn: conn, user: user}
    end

    test "valid parameters", %{conn: conn} do
      conn = put(conn, bouser_password_path(conn, :change), user: @valid_attrs)
      assert json_response(conn, 200)["user"] != %{}
    end

    test "invalid parameters", %{conn: conn} do
      conn = put(conn, bouser_password_path(conn, :change), user: Map.merge(@valid_attrs, %{new_password: "pwd"}))
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "invalid current password", %{conn: conn} do
      conn = put(conn, bouser_password_path(conn, :change), user: %{password: "invalid"})
      assert json_response(conn, 422)["errors"] == %{"password" => ["not valid"]}
    end
  end
end
