defmodule Backoffice.OrganizationControllerTest do
  use Backoffice.ConnCase

  setup %{conn: conn} do
    # to avoid ** (DBConnection.OwnershipError) cannot find ownership process for #PID<0.674.0>.
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Sso.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Sso.Repo, {:shared, self()})

    conn = put_req_header(conn, "accept", "application/json")

    {:ok, conn: conn}
  end

  describe "organization endpoint" do
    test "requires user authentication", %{conn: conn} do
      Enum.each([
          get(conn, organization_path(conn, :index)),
        ], fn conn ->
          assert json_response(conn, 498)["errors"] == %{
            "message" => "Authentication required (invalid token)"
          }
          assert conn.halted
      end)
    end
  end

  describe "organization controller" do
    setup %{conn: conn} do
      user = insert_bo_user()
      {:ok, jwt, _} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Dardy #{jwt}")

      {:ok, conn: conn, user: user}
    end

    test "list all onrganizations", %{conn: conn} do
      conn = get conn, organization_path(conn, :index)
      assert json_response(conn, 200)["organizations"] == []
    end
  end
end