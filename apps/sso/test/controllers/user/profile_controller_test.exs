defmodule Sso.User.ProfileControllerTest do
  use Sso.ConnCase

  setup %{conn: conn} do
    organization = insert_organization()
    account = insert_account(organization)
    user = insert_user(account)

    conn = put_req_header(conn, "accept", "application/vnd.dardy.sso.v1+json")

    {:ok, conn: conn, account: account, user: user}
  end

  describe "user profile endpoint" do
    test "requires account authentication", %{conn: conn, user: user} do
      conn = put(conn, user_profile_path(conn, :update, user), profile: %{})
      assert json_response(conn, 498)["errors"] == %{
        "detail" => "Authentication required (invalid token)"
      }
      assert conn.halted
    end
  end

  describe "user profile controller" do
    setup %{conn: conn, account: account, user: user} do
      {:ok, jwt, _} = Guardian.encode_and_sign(account)

      conn = put_req_header(conn, "authorization", "Dardy #{jwt}")

      account =
        account
        |> Repo.preload(:organization)

      {:ok, conn: conn, user: user, account: account}
    end

    test "update profile", %{conn: conn, user: user} do
      conn = put(
        conn,
        user_profile_path(conn, :update, user),
        profile: %{
          phone_number: "882726109998",
        }
      )

      assert json_response(conn, 200)["user"]["profile"]["phone_number"] == "882726109998"
    end

    test "does not update profile with invalid data", %{conn: conn, user: user} do
      conn = put(
        conn,
        user_profile_path(conn, :update, user),
        profile: %{
          phone_number: "",
        }
      )

      assert json_response(conn, 422)["errors"] == %{"profile" => %{"phone_number" => ["can't be blank"]}}
    end
  end
end
