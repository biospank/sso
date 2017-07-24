defmodule Sso.User.EmailChangeControllerTest do
  use Sso.ConnCase
  use Bamboo.Test, shared: :true

  @valid_attrs %{
    email: "test@example.com",
    new_email: "new.test@example.com",
    new_email_confirmation: "new.test@example.com",
    password: "secret"
  }

  describe "Email change endpoint" do
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
      Enum.each([
          post(conn, user_email_change_path(conn, :create), user: %{}),
          put(conn, user_email_change_path(conn, :update, 123))
        ], fn conn ->
          assert conn.status == 406
          assert conn.resp_body == "Not Acceptable"
          assert conn.halted
      end)

    end

    @tag :accept_header
    test "requires account authentication", %{conn: conn} do
      Enum.each([
          post(conn, user_email_change_path(conn, :create), user: %{}),
          put(conn, user_email_change_path(conn, :update, 123))
        ], fn conn ->
          assert json_response(conn, 498)["errors"] == %{
            "detail" => "Authentication required (invalid token)"
          }
          assert conn.halted
      end)
    end
  end

  describe "Email change controller #create" do
    @callback_url "http://anysite.com/resetpwd"

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

    test "valid parameters", %{conn: conn} do
      conn = post(conn, user_email_change_path(conn, :create), user: @valid_attrs)
      assert conn.status == 201
    end

    test "save new email", %{conn: conn} do
      post(conn, user_email_change_path(conn, :create), user: @valid_attrs)

      user = Repo.one(from u in Sso.User, where: u.email == ^@valid_attrs.email)

      assert user.new_email == @valid_attrs.new_email
    end

    test "invalid parameters", %{conn: conn} do
      conn = post(
        conn,
        user_email_change_path(conn, :create),
        user: Map.merge(@valid_attrs, %{new_email: ""})
      )

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "new email must be unique within the same organization", %{conn: conn} do
      conn = post(
        conn,
        user_email_change_path(conn, :create),
        user: Map.merge(@valid_attrs, %{new_email: "test@example.com", new_email_confirmation: "test@example.com"})
      )

      assert json_response(conn, 422)["errors"] == %{"new_email" => ["has already been taken"]}
    end

    test "non existent email parameters returns 404", %{conn: conn} do
      conn = post(
        conn,
        user_email_change_path(conn, :create),
        user: Map.merge(@valid_attrs, %{email: "non.existent@example.com"})
      )

      assert json_response(conn, 404)["errors"] == %{"email" => ["not found"]}
    end

    test "invalid password parameters returns 401", %{conn: conn} do
      conn = post(
        conn,
        user_email_change_path(conn, :create),
        user: Map.merge(@valid_attrs, %{password: "invalid-password"})
      )

      assert json_response(conn, 401)["errors"] == %{"password" => ["not valid"]}
    end

    test "deliver an email address change mail", %{conn: conn, account: account, user: user} do
      post_conn = post conn, user_email_change_path(conn, :create), user: @valid_attrs

      assert post_conn.status == 201
      user = Repo.get(Sso.User, user.id)

      {:ok, email} = Sso.Email.email_address_change_template(@valid_attrs.new_email, user, account, nil)

      assert_delivered_email email
    end

    test "email address change mail", %{conn: conn, account: account, user: user} do
      post_conn = post conn, user_email_change_path(conn, :create), user: @valid_attrs

      assert post_conn.status == 201
      user = Repo.get(Sso.User, user.id)

      {:ok, email} = Sso.Email.email_address_change_template(@valid_attrs.new_email, user, account, nil)

      assert email.from == account
      assert email.to == @valid_attrs.new_email
      assert email.subject == "app name - Cambio mail"
      assert email.html_body =~ "#{user.email_change_code}"
    end

    test "deliver an email address change mail with callback", %{conn: conn, account: account, user: user} do
      post_conn =
        conn
        |> post(
            user_email_change_path(conn, :create),
            user: Map.merge(@valid_attrs, %{callback_url: @callback_url})
        )

      assert post_conn.status == 201
      user = Repo.get(Sso.User, user.id)
      location = @callback_url <> "?code=#{user.email_change_code}"

      {:ok, email} = Sso.Email.email_address_change_template(@valid_attrs.new_email, user, account, location)

      assert_delivered_email email
    end

    test "email address change mail with link", %{conn: conn, account: account, user: user} do
      post_conn =
        conn
        |> post(
            user_email_change_path(conn, :create),
            user: Map.merge(@valid_attrs, %{callback_url: @callback_url})
        )

      assert post_conn.status == 201
      user = Repo.get(Sso.User, user.id)
      location = @callback_url <> "?code=#{user.reset_code}"

      {:ok, email} = Sso.Email.email_address_change_template(@valid_attrs.new_email, user, account, location)

      assert email.from == account
      assert email.to == @valid_attrs.new_email
      assert email.subject == "app name - Cambio mail"
      assert email.html_body =~ location
    end

    test "new email can be duplicated between different organizations", %{conn: conn} do
      organization = insert_organization(%{
        name: "new_name",
        ref_email: "new.org@example.com",
      })
      account =
        insert_account(
          organization,
          %{
            app_name: "app name org2",
            access_key: "gfFhHYhHFhhF",
            secret_key: "kHhiHIHkhKhIhIhKhkHHKhfYYdHHfUKhHLhLl",
            secret_hash: Comeonin.Bcrypt.hashpwsalt("kHhiHIHkhKhIhIhKhkHHKhfYYdHHfUKhHLhLl"),
          }
        ) |> Repo.preload(:organization)
      user = insert_user(
        account,
        %{email: "user.org2@example.com"}
      )
      {:ok, jwt, _} = Guardian.encode_and_sign(account)

      conn =
        conn
        |> put_req_header("accept", "application/vnd.dardy.sso.v1+json")
        |> put_req_header("authorization", "Dardy #{jwt}")

      conn = post(
        conn,
        user_email_change_path(conn, :create),
        user: Map.merge(
          @valid_attrs,
          %{
            email: user.email
          }
        )
      )

      assert conn.status == 201
    end
  end

  describe "Email change controller #update" do
    setup %{conn: conn} do
      organization = insert_organization()
      account = insert_account(organization) |> Repo.preload(:organization)
      user = insert_user(account)
      {:ok, jwt, _} = Guardian.encode_and_sign(account)

      conn =
        conn
        |> put_req_header("accept", "application/vnd.dardy.sso.v1+json")
        |> put_req_header("authorization", "Dardy #{jwt}")

        conn
        |> post(
            user_email_change_path(conn, :create),
            user: @valid_attrs
        )

      {:ok, conn: conn, account: account, user: user}
    end

    test "invalid email change code", %{conn: conn} do
      put_conn = put(conn, user_email_change_path(conn, :update, "invalid-change-code"))

      assert json_response(put_conn, 404)["errors"] == %{"code" => ["not found"]}
    end

    test "valid email change code", %{conn: conn} do
      user = Repo.one(from u in Sso.User, where: u.email == ^@valid_attrs.email)

      put_conn = put(conn, user_email_change_path(conn, :update, user.email_change_code))

      assert json_response(put_conn, 200)
    end

    test "change user email with new email", %{conn: conn} do
      user = Repo.one(from u in Sso.User, where: u.email == ^@valid_attrs.email)

      put(conn, user_email_change_path(conn, :update, user.email_change_code))

      old_user = Repo.one(from u in Sso.User, where: u.email == ^@valid_attrs.email)
      new_user = Repo.one(from u in Sso.User, where: u.email == ^@valid_attrs.new_email)

      refute old_user
      assert new_user
    end

    test "archive old user", %{conn: conn} do
      user = Repo.one(from u in Sso.User, where: u.email == ^@valid_attrs.email)

      put(conn, user_email_change_path(conn, :update, user.email_change_code))

      archived_user = Repo.one(from u in Sso.ArchivedUser, where: u.email == ^@valid_attrs.email)

      assert archived_user
    end
  end
end
