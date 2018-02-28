defmodule Sso.User.ProfileController do
  use Sso.Web, :controller

  alias Sso.{User, Profile}

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
    user =
      Repo.get_by(User, id: user_id, organization_id: account.organization_id)
      |> Repo.preload(:organization)

    cond do
      user ->
        profile_changeset =
          user.profile
          |> Profile.update_changeset(
              user.organization.settings["custom_fields"],
              profile_params
            )

        if profile_changeset.valid? do
          profile_data =
            profile_changeset
            |> Ecto.Changeset.apply_changes

          app_consents =
            user.profile
            |> Profile.add_app_consents(profile_params, account)

          profile_with_consents = Map.merge(profile_data, app_consents)

          user =
            user
            |> Ecto.Changeset.change
            |> Ecto.Changeset.put_change(:profile, profile_with_consents)
            |> Repo.update!

          render(conn, Sso.UserView, "show.json", user: user)
        else
          conn
          |> put_status(:unprocessable_entity)
          |> render(Sso.ChangesetView, "error.json", changeset: profile_changeset)
        end
      true ->
        conn
        |> put_status(:not_found)
        |> render(Sso.ErrorView, :"404", errors: %{message: gettext("User not found")})
    end
  end
end
