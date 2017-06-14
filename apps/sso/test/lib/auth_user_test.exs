defmodule Sso.Auth.UserTest do
  use Sso.ConnCase

  setup %{} do
    conn = build_conn()
    account =
      insert_organization()
      |> insert_account()
      |> Repo.preload(:organization)

    {:ok, conn: conn, account: account}
  end

  describe "login_by_email_and_password" do
    test "authenticated user", %{conn: conn, account: account} do
      user = insert_user(account, %{active: true, status: :verified})

      assert {:ok, _, _} = Sso.Auth.User.login_by_email_and_password(
        conn, user.email, user.password, repo: Sso.Repo, account: account
      )
    end

    test "inactive user", %{conn: conn, account: account} do
      user = insert_user(account, %{active: false, status: :verified})

      assert {:error, :inactive, _} = Sso.Auth.User.login_by_email_and_password(
        conn, user.email, user.password, repo: Sso.Repo, account: account
      )
    end

    test "unverified user", %{conn: conn, account: account} do
      user = insert_user(account, %{active: true, status: :unverified})

      assert {:error, :unverified, _} = Sso.Auth.User.login_by_email_and_password(
        conn, user.email, user.password, repo: Sso.Repo, account: account
      )
    end

    test "unauthorized user", %{conn: conn, account: account} do
      user = insert_user(account, %{active: true, status: :verified})

      assert {:error, :unauthorized, _} = Sso.Auth.User.login_by_email_and_password(
        conn, user.email, "invalid password", repo: Sso.Repo, account: account
      )
    end

    test "user not found", %{conn: conn, account: account} do
      user = insert_user(account, %{active: true, status: :verified})

      assert {:error, :not_found, _} = Sso.Auth.User.login_by_email_and_password(
        conn, "invalid@user", user.password, repo: Sso.Repo, account: account
      )
    end

    test "user not found for a different account", %{conn: conn, account: account} do
      user = insert_user(account, %{active: true, status: :verified})

      new_account =
        insert_organization(%{name: "NewOrg", ref_email: "neworg@example.com"})
        |> insert_account(%{app_name: "NewApp"})
        |> Repo.preload(:organization)

      assert {:error, :not_found, _} = Sso.Auth.User.login_by_email_and_password(
        conn, user.email, user.password, repo: Sso.Repo, account: new_account
      )
    end
  end
end
