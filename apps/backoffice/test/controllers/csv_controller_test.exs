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
      user = insert_bo_user()
      {:ok, jwt, _} = Guardian.encode_and_sign(user)

      {:ok, conn: conn, user: user, jwt: jwt}
    end

    test "export filtered users", %{conn: conn, jwt: jwt} do
      conn = get conn, csv_user_export_path(conn, :user_export, jwt)
      assert response_content_type(conn, :csv) =~ "charset=utf-8"
    end
  end
end
