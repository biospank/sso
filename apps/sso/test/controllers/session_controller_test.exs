defmodule Sso.SessionControllerTest do
  use Sso.ConnCase

  @valid_attrs %{
    access_key: "skkIInbIIhikIOJ",
    secret_key: "jsdjBuGHUGBGuHUBubNJbuBJBjHjNBBJbnjBNJ",
    active: true
  }

  @account_disabled %{
    access_key: "skkIInbIIhikIOJ",
    secret_key: "jsdjBuGHUGBGuHUBubNJbuBJBjHjNBBJbnjBNJ",
    active: false
  }

  setup %{conn: conn} do
    {:ok, conn: conn, organization: insert_organization()}
  end

  describe "login account" do
    setup %{conn: conn, organization: organization} do
      conn = put_req_header(conn, "accept", "application/vnd.dardy.sso.v1+json")
      {:ok, conn: conn, account: insert_account(organization, @valid_attrs)}
    end

    test "with valid credentials", %{conn: conn} do
      conn = post(
        conn,
        session_path(conn, :create),
        account: @valid_attrs
      )
      assert json_response(conn, 201)["account"]["id"]
    end

    test "with invalid access key", %{conn: conn} do
      conn = post(
        conn,
        session_path(conn, :create),
        account: Map.put(@valid_attrs, :access_key, "invalid-access-key")
      )
      assert json_response(conn, 404)["errors"] == %{
        "detail" => "account not found"
      }

      # assert_error_sent :not_found, fn ->
      #   conn = post(
      #     conn,
      #     session_path(conn, :create),
      #     account: Map.put(@valid_attrs, :access_key, "invalid-access-key")
      #   )
      # end
    end

    test "with invalid secret key", %{conn: conn} do
      conn = post(
        conn,
        session_path(conn, :create),
        account: Map.put(@valid_attrs, :secret_key, "invalid-secret-key")
      )
      assert json_response(conn, 401)["errors"] == %{
        "detail" => "account unauthorized"
      }
    end
  end

  describe "disabled account" do
    setup %{conn: conn, organization: organization} do
      account = insert_account(organization, @account_disabled)
      conn = put_req_header(conn, "accept", "application/vnd.dardy.sso.v1+json")
      {:ok, conn: conn, account: account}
    end

    test "cannot access", %{conn: conn, account: account} do
      post_conn = post(
        conn,
        session_path(conn, :create),
        account: %{
          access_key: account.access_key,
          secret_key: account.secret_key
        }
      )
      assert json_response(post_conn, 423)["errors"] == %{
        "detail" => "account temporary disabled"
      }
    end
  end
end
