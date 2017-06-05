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
    changeset =
      account
      |> build_assoc(:users, %{organization_id: account.organization_id})
      |> User.registration_changeset(user_params)
      |> Profile.add_app_consents(user_params, account)
      |> User.authorize_changeset

    case Repo.insert(changeset) do
      {:ok, user} ->
        account =
          account
          |> Repo.preload(:organization)

        case get_in(account.organization.settings, ["email_template", "verification", "active"]) do
          value when value in [true, nil] ->
            case Email.courtesy_email(user, account) do
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
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Sso.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def create(conn, %{"user" => user_params}, account) do
    changeset =
      account
      |> build_assoc(:users, %{organization_id: account.organization_id})
      |> User.registration_changeset(user_params)
      |> Profile.add_app_consents(user_params, account)

    case Repo.insert(changeset) do
      {:ok, user} ->
        link = User.gen_registration_link(user, user_params)
        account =
          account
          |> Repo.preload(:organization)

        case Email.welcome_email(user, account, link) do
          {:error, message} ->
            Logger.error message
          {:ok, email} ->
            Mailer.deliver_later(email)
        end

        Email.account_new_registration_email(user, account) |> Mailer.deliver_later
        Email.dardy_new_registration_email(user, account) |> Mailer.deliver_later

        conn
        |> put_status(:created)
        |> put_location_resp_header(link)
        |> render(Sso.UserView, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Sso.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp put_location_resp_header(conn, link) when is_binary(link) do
    put_resp_header(conn, "location", link)
  end
  defp put_location_resp_header(conn, _) do
    conn
  end
end
