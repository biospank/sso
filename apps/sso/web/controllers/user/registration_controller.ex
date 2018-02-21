defmodule Sso.User.RegistrationController do
  use Sso.Web, :controller
  require Logger

  alias Sso.{User, Profile, Email, Mailer}

  plug :scrub_params, "user"

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [
        conn,
        conn.params,
        Guardian.Plug.current_resource(conn)
      ]
    )
  end

  def create(conn, %{"user" => user_params, "authorize" => _}, account) do
    user_changeset =
      account
      |> build_assoc(:users, %{organization_id: account.organization_id})
      |> User.registration_changeset(user_params)
      |> User.activate_and_authorize_changeset

    if user_changeset.valid? do
      account =
        account
        |> Repo.preload(:organization)

      profile_changeset =
        account.organization.settings["custom_fields"]
        |> Profile.registration_changeset(user_params["profile"])

      if profile_changeset.valid? do
        profile_data =
          profile_changeset
          |> Ecto.Changeset.apply_changes
          |> Profile.add_app_consents(user_params["profile"], account)

        user =
          user_changeset
          |> Ecto.Changeset.put_change(:profile, profile_data)
          |> Repo.insert!

        # reload user to get profile with string keys
        user = User |> Repo.get!(user.id)

        case get_in(account.organization.settings, ["email_template", "verification", "active"]) do
          value when value in [true, nil] ->
            case Email.courtesy_template(user, account) do
              {:error, message} ->
                Logger.error message
              {:ok, email} ->
                Sso.Mailer.deliver_later(email)
            end
          _ ->
            false
        end

        conn
        |> put_status(:created)
        |> render(Sso.UserView, "show.json", user: user)
      else
        conn
        |> put_status(:unprocessable_entity)
        |> render(Sso.ChangesetView, "error.json", changeset: profile_changeset)
      end
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Sso.ChangesetView, "error.json", changeset: user_changeset)
    end
  end

  def create(conn, %{"user" => user_params}, account) do
    user_changeset =
      account
      |> build_assoc(:users, %{organization_id: account.organization_id})
      |> User.registration_changeset(user_params)

    if user_changeset.valid? do
      account =
        account
        |> Repo.preload(:organization)

      profile_changeset =
        account.organization.settings["custom_fields"]
        |> Profile.registration_changeset(user_params["profile"])

      if profile_changeset.valid? do
        profile_data =
          profile_changeset
          |> Ecto.Changeset.apply_changes
          |> Profile.add_app_consents(user_params["profile"], account)

        user =
          user_changeset
          |> Ecto.Changeset.put_change(:profile, profile_data)
          |> Repo.insert!

        # reload user to get profile with string keys
        user = User |> Repo.get!(user.id)

        link = User.gen_activation_link(user, user_params)

        case Email.welcome_template(user, account, link) do
          {:error, message} ->
            Logger.error message
          {:ok, email} ->
            Mailer.deliver_later(email)
        end

        Email.account_new_registration_template(user, account) |> Mailer.deliver_later
        # Email.dardy_new_registration_template(user, account) |> Mailer.deliver_later

        conn
        |> put_status(:created)
        |> put_location_resp_header(link)
        |> render(Sso.UserView, "show.json", user: user)
      else
        conn
        |> put_status(:unprocessable_entity)
        |> render(Sso.ChangesetView, "error.json", changeset: profile_changeset)
      end
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Sso.ChangesetView, "error.json", changeset: user_changeset)
    end
  end

  defp put_location_resp_header(conn, link) when is_binary(link) do
    put_resp_header(conn, "location", link)
  end
  defp put_location_resp_header(conn, _) do
    conn
  end
end
