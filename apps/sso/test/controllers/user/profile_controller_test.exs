defmodule Sso.User.ProfileControllerTest do
  use Sso.ConnCase

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
      privacy_consent: false,
      province_enployment: "Roma"
    }
  }

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

    test "update profile", %{conn: conn} do
      post_conn = post conn, user_registration_path(conn, :create), user: @valid_attrs

      user = Repo.get(Sso.User, json_response(post_conn, 201)["user"]["id"])

      conn = put(
        conn,
        user_profile_path(conn, :update, user),
        profile: %{
          phone_number: "882726109998",
        }
      )

      assert json_response(conn, 200)["user"]["profile"]["phone_number"] == "882726109998"
    end

    test "does not update profile with invalid data", %{conn: conn} do
      post_conn = post conn, user_registration_path(conn, :create), user: @valid_attrs

      user = Repo.get(Sso.User, json_response(post_conn, 201)["user"]["id"])

      put_conn = put(
        conn,
        user_profile_path(conn, :update, user),
        profile: %{
          phone_number: "",
        }
      )

      assert json_response(put_conn, 422)["errors"] == %{"profile" => %{"phone_number" => ["can't be blank"]}}
    end

    # L'aggiornamento del profilo utente può essere effettuato
    # per un utente appartenente alla stessa organizzazione dell'account
    # che è stato autenticato.
    # Nel test seguente l'account autenticato è nel setup mentre
    # l'utente per cui viene aggiornato il profilo appartiene
    # ad un altro account (non autenticato) di un organizzazione diversa.
    test "profile update can be done by one of the same organization's authorized account", %{conn: conn} do
      new_organization = insert_organization(%{
        name: "new name",
        ref_email: "neworg@example.com"
      })
      new_account = insert_account(new_organization, %{
        app_name: "new app name"
      })
      new_user = insert_user(new_account, %{
        email: "newuser@example.com"
      })

      put_conn = put(
        conn,
        user_profile_path(conn, :update, new_user),
        profile: %{
          phone_number: "882726109998",
        }
      )

      assert json_response(put_conn, 404)["errors"] == %{
        "detail" => "User not found"
      }
    end
  end
end
