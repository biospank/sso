defmodule Backoffice.CsvControllerTest do
  use Backoffice.ConnCase

  describe "Csv endpoint" do
    test "requires user authentication", %{conn: conn} do
      Enum.each([
          get(conn, csv_user_export_path(conn, :user_export, "WrONgJwT"))
        ], fn conn ->
          assert html_response(conn, 498)
      end)
    end
  end

  describe "Csv controller" do
    setup %{conn: conn} do
      organization = insert_bo_organization()
      user = insert_bo_user()
      {:ok, jwt, _} = Guardian.encode_and_sign(user)

      {:ok, conn: conn, user: user, jwt: jwt, org: organization}
    end

    test "export filtered users", %{conn: conn, jwt: jwt, org: org} do
      filters = %{
        "field" => nil,
        "term" => nil,
        "email" => nil,
        "status" => nil,
        "account" => nil,
        "organization" => org.id
      }

      conn = get(
        conn,
        csv_user_export_path(conn, :user_export, jwt, filters: filters)
      )
      assert response_content_type(conn, :csv) =~ "charset=utf-8"
    end
  end
end
