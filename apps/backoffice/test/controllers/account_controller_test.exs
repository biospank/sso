defmodule Backoffice.AccountControllerTest do
  use Backoffice.ConnCase

  @valid_attrs %{
    app_name: "CompanyName",
    ref_email: "company@example.com"
  }

  @invalid_attrs %{
    ref_email: "company@example.com"
  }

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
          get(conn, account_path(conn, :index)),
          post(conn, account_path(conn, :create))
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

    test "list all accounts", %{conn: conn} do
      conn = get conn, account_path(conn, :index)
      assert json_response(conn, 200)["accounts"] == []
    end

    test "create account with an existing organization", %{conn: conn} do
      org = insert_organization()

      conn = post conn, account_path(conn, :create), account: Map.merge(@valid_attrs, %{org_id: org.id})
      assert json_response(conn, 201)
    end

    test "create account with a new organization", %{conn: conn} do
      org = %{name: "OrganizationName", ref_email: "org@example.com"}

      conn = post conn, account_path(conn, :create), account: Map.merge(@valid_attrs, %{org: org})
      assert json_response(conn, 201)
    end

    test "doesn't create an invalid account", %{conn: conn} do
      org = insert_organization()

      conn = post conn, account_path(conn, :create), account: Map.merge(@invalid_attrs, %{org_id: org.id})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
