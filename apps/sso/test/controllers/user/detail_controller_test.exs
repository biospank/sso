defmodule Sso.User.DetailControllerTest do
  use Sso.ConnCase

  describe "Detail controller endpoint" do
    setup %{conn: conn} = config do
      if config[:accept_header] do
        conn =
          conn
          |> put_req_header("accept", "application/vnd.dardy.sso.v1+json")

          {:ok, conn: conn}
      else
        {:ok, conn: conn}
      end
    end

    test "requires accept header", %{conn: conn} do
      get_conn = get conn, user_detail_path(conn, :show, 123)

      assert get_conn.status == 406
      assert get_conn.resp_body == "Not Acceptable"
      assert get_conn.halted
    end

    @tag :accept_header
    test "requires account authentication", %{conn: conn} do
      get_conn = get conn, user_detail_path(conn, :show, 123)

      assert json_response(get_conn, 498)["errors"] == %{
        "detail" => "Authentication required (invalid token)"
      }
      assert get_conn.halted
    end
  end

  describe "detail controller" do
    setup %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization) |> Repo.preload(:organization)
      user = insert_user(account)
      {:ok, jwt, _} = Guardian.encode_and_sign(account)

      conn =
        conn
        |> put_req_header("accept", "application/vnd.dardy.sso.v1+json")
        |> put_req_header("authorization", "Dardy #{jwt}")

      {:ok, conn: conn, account: account, user: user}
    end

    test "existing user", %{conn: conn, user: user} do
      get_conn = get conn, user_detail_path(conn, :show, user.id)

      assert json_response(get_conn, 200)["user"]["id"]
    end

    test "non existing user", %{conn: conn} do
      get_conn = get conn, user_detail_path(conn, :show, 123)

      assert json_response(get_conn, 404)["errors"] == %{"detail" => "User not found"}
    end
  end
end
