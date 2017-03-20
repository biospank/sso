defmodule Backoffice.UserControllerTest do
  use Backoffice.ConnCase
  use Bamboo.Test, shared: :true

  setup %{conn: conn} do
    # to avoid ** (DBConnection.OwnershipError) cannot find ownership process for #PID<0.674.0>.
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Sso.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Sso.Repo, {:shared, self()})

    conn = put_req_header(conn, "accept", "application/json")

    {:ok, conn: conn}
  end

  describe "user endpoint" do
    test "requires user authentication", %{conn: conn} do
      Enum.each([
          get(conn, user_path(conn, :index)),
          put(conn, user_activate_path(conn, :activate, 123)),
          put(conn, user_authorize_path(conn, :authorize, 123))
        ], fn conn ->
          assert json_response(conn, 498)["errors"] == %{
            "message" => "Richiesta autorizzazione (token non valido)"
          }
          assert conn.halted
      end)
    end
  end

  describe "user controller" do
    setup %{conn: conn} do
      user = insert_bo_user()
      {:ok, jwt, _} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Dardy #{jwt}")

      {:ok, conn: conn, user: user}
    end

    test "list all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200)["users"] == []
    end

    test "show user", %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization)
      user = insert_user(account)

      conn = get conn, user_path(conn, :show, user)
      assert json_response(conn, 200)["user"]["id"] == user.id
    end

    test "activate user", %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization)
      user = insert_user(account)

      conn = put conn, user_activate_path(conn, :activate, user)
      assert json_response(conn, 200)["user"]["active"] == true
    end

    test "deactivate user", %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization)
      user = insert_user(account)

      conn = put conn, user_deactivate_path(conn, :deactivate, user)
      assert json_response(conn, 200)["user"]["active"] == false
    end

    test "authorize user", %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization)
      user = insert_user(account)

      conn = put conn, user_authorize_path(conn, :authorize, user)
      assert json_response(conn, 200)["user"]["status"] == "verified"
    end

    test "deliver a courtesy email", %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization)
      user = insert_user(account)

      conn = put conn, user_authorize_path(conn, :authorize, user)
      user = Sso.Repo.get(Sso.User, json_response(conn, 200)["user"]["id"])
      account =
        Sso.Account
        |> Ecto.Query.preload(:organization)
        |> Sso.Repo.get!(user.account_id)

      assert_delivered_email Sso.Email.courtesy_email(user, account)
    end

    test "welcome email", %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization)
      user = insert_user(account)

      conn = put conn, user_authorize_path(conn, :authorize, user)
      user = Sso.Repo.get(Sso.User, json_response(conn, 200)["user"]["id"])
      account =
        Sso.Account
        |> Ecto.Query.preload(:organization)
        |> Sso.Repo.get!(user.account_id)

      email = Sso.Email.courtesy_email(user, account)
      assert email.to == user
      assert email.subject == "Sso - Verifica utente"
      assert email.html_body =~ user.profile.first_name
    end
  end
end
