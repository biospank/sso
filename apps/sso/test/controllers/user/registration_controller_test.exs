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
      sso_privacy_consent: true,
      privacy_consent: true,
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
      sso_privacy_consent: true,
      privacy_consent: true,
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

    test "expects app privacy consents not to be empty", %{conn: conn} do
      conn =
        conn
        |> post(
            user_registration_path(conn, :create),
            user: @valid_attrs
          )

      refute Enum.empty?(json_response(conn, 201)["user"]["profile"]["app_consents"])
    end

    test "expects account app privacy consent to be present", %{conn: conn, account: account} do
      conn =
        conn
        |> post(
            user_registration_path(conn, :create),
            user: @valid_attrs
          )

      [first_consent | []] = json_response(conn, 201)["user"]["profile"]["app_consents"]

      assert (first_consent |> Map.get("app_id")) ==  account.id
      assert (first_consent |> Map.get("app_name")) ==  account.app_name
      assert (first_consent |> Map.get("privacy")) ==  get_in(@valid_attrs, [:profile, :privacy_consent])
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
      {:ok, email} = Sso.Email.welcome_email(user, account, nil)
      assert_delivered_email email
    end

    test "welcome email", %{conn: conn, account: account} do
      conn = post conn, user_registration_path(conn, :create), user: @new_user
      user = Repo.get(User, json_response(conn, 201)["user"]["id"])
      {:ok, email} = Sso.Email.welcome_email(user, account, nil)

      assert email.from == account
      assert email.to == user
      assert email.subject == "app name - Richiesta registrazione"
      assert email.html_body =~ "Gentile first name last name"
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
      {:ok, email} = Sso.Email.welcome_email(user, account, location)

      assert_delivered_email email
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
      {:ok, email} = Sso.Email.welcome_email(user, account, location)

      assert email.from == account
      assert email.to == user
      assert email.subject == "app name - Richiesta registrazione"
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
      assert email.subject == "app name - Notifica registazione utente"
      assert email.html_body =~ "Nome utente - first name last name"
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
      assert email.subject == "app name - Notifica registazione utente"
      assert email.html_body =~ "Spettabile name"
    end

    test "bypass activation and authorization when 'authorize' param is sent", %{conn: conn} do
      conn = post conn, user_registration_path(conn, :create), user: @new_user, authorize: true
      user = Repo.get(User, json_response(conn, 201)["user"]["id"])
      assert user.active == true
      assert user.status == :verified
    end

    test "deliver a courtesy email to the user", %{conn: conn, account: account} do
      conn = post conn, user_registration_path(conn, :create), user: @new_user, authorize: true
      user = Repo.get(User, json_response(conn, 201)["user"]["id"])
      {:ok, email} = Sso.Email.courtesy_email(user, account)
      assert_delivered_email email
    end

    test "user courtesy email", %{conn: conn, account: account} do
      conn = post conn, user_registration_path(conn, :create), user: @new_user, authorize: true
      user = Repo.get(User, json_response(conn, 201)["user"]["id"])
      {:ok, email} = Sso.Email.courtesy_email(user, account)
      assert email.from == account
      assert email.to == user
      assert email.subject == "app name - Conferma registrazione"
      assert email.html_body =~ user.profile.first_name
    end
  end
end
