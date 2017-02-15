defmodule Sso.User.ProfileController do
  use Sso.Web, :controller

  alias Sso.{User, Profile}

  plug :scrub_params, "profile"

  def update(conn, %{"id" => user_id, "profile" => profile_params}) do
    user =
      User
      |> Repo.get(user_id)

    cond do
      user ->
        profile_changeset =
          user.profile
          |> Profile.changeset(profile_params)

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
        |> render(Sso.ErrorView, :"404", errors: %{message: "User not found"})
    end
  end
end
