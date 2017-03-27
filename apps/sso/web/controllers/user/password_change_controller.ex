defmodule Sso.User.PasswordChangeController do
  use Sso.Web, :controller

  alias Sso.User

  plug :scrub_params, "user" when action in [:change]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [
        conn,
        conn.params,
        Guardian.Plug.current_resource(conn)
      ]
    )
  end

  def change(conn, %{"id" => user_id, "user" => user_params}, account) do
    user = Repo.get_by(User, id: user_id, organization_id: account.organization_id)

    case user do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(Sso.ErrorView, :"404", errors: %{message: gettext("User not found")})
      user ->
        case Comeonin.Bcrypt.checkpw(user_params["password"], user.password_hash) do
          true ->
            changeset = User.password_change_changeset(user, user_params)

            case Repo.update(changeset) do
              {:ok, user} ->
                render(conn, Sso.UserView, "show.json", user: user)
              {:error, changeset} ->
                conn
                |> put_status(:unprocessable_entity)
                |> render(Sso.ChangesetView, "error.json", changeset: changeset)
            end
          false ->
            changeset =
              Ecto.Changeset.change(%User{}, %{password: ""})
              |> Ecto.Changeset.add_error(:password, gettext("not valid"))

            conn
            |> put_status(:unprocessable_entity)
            |> render(Sso.ChangesetView, "error.json", changeset: changeset)
        end
    end
  end
end
