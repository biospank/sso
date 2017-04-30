defmodule Sso.User.ProfileController do
  use Sso.Web, :controller

  alias Sso.{User, Profile, Consent}

  plug :scrub_params, "profile"

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [
        conn,
        conn.params,
        Guardian.Plug.current_resource(conn)
      ]
    )
  end

  def update(conn, %{"id" => user_id, "profile" => profile_params}, account) do
    user = Repo.get_by(User, id: user_id, organization_id: account.organization_id)

    cond do
      user ->
        app_consents_changeset =
          user.profile.app_consents
          |> Consent.update_app_consents_changeset(account, profile_params)

        profile_changeset =
          user.profile
          |> Profile.update_changeset(profile_params)
          |> Ecto.Changeset.put_embed(:app_consents, app_consents_changeset)

        changeset =
          user
          |> Ecto.Changeset.change
          |> Ecto.Changeset.put_embed(:profile, profile_changeset)

        case Repo.update(changeset) do
          {:ok, user} ->
            render(conn, Sso.UserView, "show.json", user: user)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Sso.ChangesetView, "error.json", changeset: changeset)
        end
      true ->
        conn
        |> put_status(:not_found)
        |> render(Sso.ErrorView, :"404", errors: %{message: gettext("User not found")})
    end
  end
end
