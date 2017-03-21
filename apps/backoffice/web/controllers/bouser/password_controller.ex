defmodule Backoffice.BoUser.PasswordController do
  use Backoffice.Web, :controller

  alias Backoffice.{User, Repo}

  # plug :scrub_params, "user" when action in [:change]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [
        conn,
        conn.params,
        Guardian.Plug.current_resource(conn)
      ]
    )
  end

  def change(conn, %{"user" => user_params}, user) do
    case Comeonin.Bcrypt.checkpw(user_params["password"], user.password_hash) do
      true ->
        changeset = User.password_changeset(user, user_params)

        case Repo.update(changeset) do
          {:ok, user} ->
            render(conn, Backoffice.UserView, "show.json", user: user)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Backoffice.ChangesetView, "error.json", changeset: changeset)
        end
      false ->
        conn
        |> put_status(401)
        |> render(Backoffice.ErrorView, :"401", errors: %{password: gettext("Password not valid")})
    end
  end
end
