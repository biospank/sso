defmodule Backoffice.OrganizationControllerTest do
  use Backoffice.ConnCase

  @valid_attrs %{
    name: "TestOrg",
    ref_email: "test@example.com",
    setting: %{}
  }

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
          post(conn, organization_path(conn, :create), organization: %{}),
          put(conn, organization_path(conn, :update, 123), organization: %{})
        ], fn conn ->
          assert json_response(conn, 498)["errors"] == %{
            "message" => "Richiesta autorizzazione (token non valido)"
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

    test "list all organizations", %{conn: conn} do
      conn = get conn, organization_path(conn, :index)
      assert json_response(conn, 200)["organizations"] == []
    end

    test "valid organization", %{conn: conn} do
      conn = post conn, organization_path(conn, :create), organization: @valid_attrs
      assert conn.status == 201
    end

    test "invalid organization", %{conn: conn} do
      conn = post conn, organization_path(conn, :create), organization: %{ref_email: "test@example.com"}
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "update email settings", %{conn: conn} do
      new_settings = %{
        "email_template" => %{
          "web" => %{},
          "mobile" => %{}
        }
      }

      org = %Sso.Organization{}
      |> Sso.Organization.registration_changeset(@valid_attrs)
      |> Sso.Repo.insert!

      put_conn = put(
        conn,
        organization_path(conn, :update, org),
        organization: Map.put(@valid_attrs, :settings, new_settings)
      )

      assert json_response(put_conn, 200)["organization"]["settings"] == new_settings
    end
  end
end
