defmodule Sso.User.RegistrationControllerTest do
  use Sso.ConnCase
  use Bamboo.Test, shared: :true

  alias Sso.User

  @account %{
    access_key: "skkIInbIIhikIOJ",
    secret_key: "jsdjBuGHUGBGuHUBubNJbuBJBjHjNBBJbnjBNJ",
    active: true
  }

  @valid_attrs %{
    email: "some@content",
    password: "secret",
    password_confirmation: "secret",
    profile: %{
      first_name: "first name",
      last_name: "last name",
      fiscal_code: "ggrsta21s50h501z",
      date_of_birth: "1997-02-12",
      place_of_birth: "Roma",
      phone_number: "227726622",
      profession: "Medico generico",
      specialization: "Pediatria",
      board_member: "Medici",
      board_number: "3773662882",
      province_board: "Roma",
      employment: "Medico generico",
      province_enployment: "Roma"
    }
  }
  @invalid_attrs %{}

  @new_user %{
    email: "some_other@content",
    password: "secret",
    password_confirmation: "secret",
    profile: %{
      first_name: "first name",
      last_name: "last name",
      fiscal_code: "ggrsta21s50h501z",
      date_of_birth: "1997-02-12",
      place_of_birth: "Roma",
      phone_number: "227726622",
      profession: "Medico generico",
      specialization: "Pediatria",
      board_member: "Medici",
      board_number: "3773662882",
      province_board: "Roma",
      employment: "Medico generico",
      province_enployment: "Roma"
    }
  }

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/vnd.dardy.sso.v1+json")

    {:ok, conn: conn}
  end

  describe "registation endpoint" do
    test "requires account authentication", %{conn: conn} do
      conn = post(conn, user_registration_path(conn, :create), user: @new_user)
      assert json_response(conn, 498)["errors"] == %{
        "detail" => "Authentication required (invalid token)"
      }
      assert conn.halted
    end
  end

  describe "registration controller" do
    @callback_url "http://anysite.com/opt-in"

    setup %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization, @account)
      {:ok, jwt, _} = Guardian.encode_and_sign(account)

      conn = put_req_header(conn, "authorization", "Dardy #{jwt}")

      account =
        account
        |> Repo.preload(:organization)

      {:ok, conn: conn, account: account}
    end

    test "does not create resource and renders errors when data is not valid", %{conn: conn} do
      conn = post conn, user_registration_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "creates and register user when data is valid", %{conn: conn} do
      conn = post conn, user_registration_path(conn, :create), user: @new_user
      assert json_response(conn, 201)["user"]["id"]
    end

    test "does not create resource and renders errors when profile is not provided", %{conn: conn} do
      conn =
        conn
        |> post(
            user_registration_path(conn, :create),
            user: Map.delete(@valid_attrs, :profile)
          )

      assert json_response(conn, 422)["errors"] ["errors"] != %{}
    end

    test "associate a newly created user by the authenticated account", %{conn: conn, account: account} do
      post conn, user_registration_path(conn, :create), user: @new_user

      assert Repo.one(User).account_id == account.id
    end

    test "expects a location response header if a callback url is provided", %{conn: conn} do
      post_conn =
        conn
        |> post(
            user_registration_path(conn, :create),
            user: Map.merge(@new_user, %{"callback_url" => @callback_url})
        )
      [location] = get_resp_header(post_conn, "location")
      assert String.starts_with?(location, @callback_url)
    end

    test "expects an empty location response header if a callback url is not provided", %{conn: conn} do
      post_conn =
        conn
        |> post(user_registration_path(conn, :create), user: @new_user)
      assert get_resp_header(post_conn, "location") == []
    end

    test "deliver a welcome email", %{conn: conn, account: account} do
      conn = post conn, user_registration_path(conn, :create), user: @new_user
      user = Repo.get(User, json_response(conn, 201)["user"]["id"])
      assert_delivered_email Sso.Email.welcome_email(user, account, nil)
    end

    test "welcome email", %{conn: conn, account: account} do
      conn = post conn, user_registration_path(conn, :create), user: @new_user
      user = Repo.get(User, json_response(conn, 201)["user"]["id"])
      email = Sso.Email.welcome_email(user, account, nil)
      assert email.from == account
      assert email.to == user
      assert email.subject == "Sso - Registazione utente"
      assert email.html_body =~ "Codice di attivazione: #{user.activation_code}"
    end

    test "deliver a welcome email with callback", %{conn: conn, account: account} do
      post_conn =
        conn
        |> post(
            user_registration_path(conn, :create),
            user: Map.merge(@new_user, %{"callback_url" => @callback_url})
        )
      user = Repo.get(User, json_response(post_conn, 201)["user"]["id"])
      location = @callback_url <> "?code=#{user.activation_code}"
      assert_delivered_email Sso.Email.welcome_email(user, account, location)
    end

    test "welcome email with link", %{conn: conn, account: account} do
      post_conn =
        conn
        |> post(
            user_registration_path(conn, :create),
            user: Map.merge(@new_user, %{"callback_url" => @callback_url})
        )
      user = Repo.get(User, json_response(post_conn, 201)["user"]["id"])
      location = @callback_url <> "?code=#{user.activation_code}"
      email = Sso.Email.welcome_email(user, account, location)
      assert email.from == account
      assert email.to == user
      assert email.subject == "Sso - Registazione utente"
      assert email.html_body =~ location
    end

    test "deliver a notification email to Dardy", %{conn: conn, account: account} do
      conn = post conn, user_registration_path(conn, :create), user: @new_user
      user = Repo.get(User, json_response(conn, 201)["user"]["id"])
      assert_delivered_email Sso.Email.dardy_new_registration_email(user, account)
    end

    test "dardy notification email", %{conn: conn, account: account} do
      conn = post conn, user_registration_path(conn, :create), user: @new_user
      user = Repo.get(User, json_response(conn, 201)["user"]["id"])
      email = Sso.Email.dardy_new_registration_email(user, account)
      assert email.from == account
      assert email.to == Application.fetch_env!(:sso, :recipient_email_notification)
      assert email.subject == "Sso - Notifica registazione utente"
      assert email.html_body =~ "Registrazione utente #{account.organization.name}"
    end

    test "deliver a notification email to the account", %{conn: conn, account: account} do
      conn = post conn, user_registration_path(conn, :create), user: @new_user
      user = Repo.get(User, json_response(conn, 201)["user"]["id"])
      assert_delivered_email Sso.Email.account_new_registration_email(user, account)
    end

    test "account notification email", %{conn: conn, account: account} do
      conn = post conn, user_registration_path(conn, :create), user: @new_user
      user = Repo.get(User, json_response(conn, 201)["user"]["id"])
      email = Sso.Email.account_new_registration_email(user, account)
      assert email.from == Application.fetch_env!(:sso, :recipient_email_notification)
      assert email.to == account
      assert email.subject == "Sso - Notifica registazione utente"
      assert email.html_body =~ "Registrazione utente #{account.organization.name}"
    end
  end
end
