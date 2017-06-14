defmodule Sso.Auth.AccountTest do
  use Sso.ConnCase

  setup %{} do
    conn = build_conn()
    org = insert_organization()

    {:ok, conn: conn, org: org}
  end

  describe "login_by_access_key_and_secret_key" do
    test "authenticated account", %{conn: conn, org: org} do
      account = org |> insert_account(%{active: true})

      {:ok, _, _} = Guardian.encode_and_sign(account)

      assert {:ok, _, _} = Sso.Auth.Account.login_by_access_key_and_secret_key(
        conn, account.access_key, account.secret_key, repo: Sso.Repo
      )
    end

    test "locked account", %{conn: conn, org: org} do
      account = org |> insert_account(%{active: false})

      {:ok, _, _} = Guardian.encode_and_sign(account)

      assert {:error, :locked, _} = Sso.Auth.Account.login_by_access_key_and_secret_key(
        conn, account.access_key, account.secret_key, repo: Sso.Repo
      )
    end

    test "unauthorized account", %{conn: conn, org: org} do
      account = org |> insert_account(%{active: true})

      {:ok, _, _} = Guardian.encode_and_sign(account)

      assert {:error, :unauthorized, _} = Sso.Auth.Account.login_by_access_key_and_secret_key(
        conn, account.access_key, "wrongsecretkey", repo: Sso.Repo
      )
    end

    test "account not found", %{conn: conn, org: org} do
      account = org |> insert_account(%{active: true})

      {:ok, _, _} = Guardian.encode_and_sign(account)

      assert {:error, :not_found, _} = Sso.Auth.Account.login_by_access_key_and_secret_key(
        conn, "wrongaccesskey", account.secret_key, repo: Sso.Repo
      )
    end
  end
end
