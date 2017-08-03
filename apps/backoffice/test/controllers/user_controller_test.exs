defmodule Backoffice.UserControllerTest do
  use Backoffice.ConnCase
  use Bamboo.Test, shared: :true

  @password_change_valid_attrs %{
    "new_password" => "new_secret123",
    "new_password_confirmation" => "new_secret123"
  }

  @email_change_valid_attrs %{
    "new_email" => "test.new.email@example.com",
    "new_email_confirmation" => "test.new.email@example.com"
  }

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
          put(conn, user_authorize_path(conn, :authorize, 123)),
          put(conn, user_password_change_path(conn, :password_change, 123)),
          put(conn, user_email_change_path(conn, :email_change, 123))
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

    test "change password", %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization)
      user = insert_user(account)

      conn = put conn, user_password_change_path(conn, :password_change, user), user: @password_change_valid_attrs
      assert conn.status == 200
    end

    test "change password with invalid attrs", %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization)
      user = insert_user(account)

      conn = put conn, user_password_change_path(conn, :password_change, user), user: %{}
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "change email", %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization)
      user = insert_user(account)

      conn = put conn, user_email_change_path(conn, :email_change, user), user: @email_change_valid_attrs
      assert conn.status == 200
    end

    test "change email with invalid attrs", %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization)
      user = insert_user(account)

      conn = put conn, user_email_change_path(conn, :email_change, user), user: %{}
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "change email with existing email into the same organization", %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization)
      insert_user(account, %{
          email: "user1@example.com"
        })
      user2 = insert_user(account, %{
          email: "user2@example.com"
        })

      conn = put(
        conn,
        user_email_change_path(conn, :email_change, user2),
        user: %{
          "new_email" => "user1@example.com",
          "new_email_confirmation" => "user1@example.com"
        }
      )

      assert json_response(conn, 422)["errors"] == %{"email" => ["è già stato utilizzato"]}
    end

    test "change email with existing email into the same organization case insensitive", %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization)
      insert_user(account, %{
          email: "user1@example.com"
        })
      user2 = insert_user(account, %{
          email: "user2@example.com"
        })

      conn = put(
        conn,
        user_email_change_path(conn, :email_change, user2),
        user: %{
          "new_email" => "uSeR1@example.com",
          "new_email_confirmation" => "uSeR1@example.com"
        }
      )

      assert json_response(conn, 422)["errors"] == %{"email" => ["è già stato utilizzato"]}
    end


    test "change user email with new email", %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization)
      user = insert_user(account)

      put(conn, user_email_change_path(conn, :email_change, user), user: @email_change_valid_attrs)

      old_user = Sso.Repo.one(from u in Sso.User, where: u.email == ^user.email)
      new_user = Sso.Repo.get_by(Sso.User, email: "test.new.email@example.com")

      refute old_user
      assert new_user
    end

    test "archive old user", %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization)
      user = insert_user(account)

      put(conn, user_email_change_path(conn, :email_change, user), user: @email_change_valid_attrs)

      archived_user = Sso.Repo.one(
        from u in Sso.ArchivedUser,
        where: u.email == ^user.email and
          u.new_email == ^Map.get(@email_change_valid_attrs, "new_email")
      )

      assert archived_user
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

      {:ok, email} = Sso.Email.courtesy_template(user, account)
      assert_delivered_email email
    end

    test "does not deliver a courtesy email if verification active flag is false", %{conn: conn} do
      organization = insert_organization(
        settings: %{
          email_template: %{
            verification: %{
              active: false
            }
          }
        }
      )

      account = insert_account(organization)
      user = insert_user(account)

      conn = put conn, user_authorize_path(conn, :authorize, user)
      user = Sso.Repo.get(Sso.User, json_response(conn, 200)["user"]["id"])
      account =
        Sso.Account
        |> Ecto.Query.preload(:organization)
        |> Sso.Repo.get!(user.account_id)

      {:ok, email} = Sso.Email.courtesy_template(user, account)
      refute_delivered_email email
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

      {:ok, email} = Sso.Email.courtesy_template(user, account)
      assert email.to == user
      assert email.subject == "app name - Conferma registrazione"
      assert email.html_body =~ user.profile.first_name
    end
  end
end
