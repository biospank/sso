defmodule Backoffice.AccountControllerTest do
  use Backoffice.ConnCase

  setup %{conn: conn} do
    # to avoid ** (DBConnection.OwnershipError) cannot find ownership process for #PID<0.674.0>.
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Sso.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Sso.Repo, {:shared, self()})

    conn = put_req_header(conn, "accept", "application/json")

    {:ok, conn: conn}
  end

  describe "account endpoint" do
    test "requires user authentication", %{conn: conn} do
      Enum.each([
          post(conn, account_path(conn, :create)),
        ], fn conn ->
          assert json_response(conn, 498)["errors"] == %{
            "message" => "Authentication required (invalid token)"
          }
          assert conn.halted
      end)
    end
  end

  describe "account controller" do
    setup %{conn: conn} do
      user = insert_bo_user()
      {:ok, jwt, _} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Dardy #{jwt}")

      {:ok, conn: conn, user: user}
    end

    test "create account", %{conn: conn} do
      conn = post conn, account_path(conn, :create)
      assert json_response(conn, 201)
    end
  end
end
