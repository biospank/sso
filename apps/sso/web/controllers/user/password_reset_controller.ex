defmodule Sso.User.PasswordResetController do
  use Sso.Web, :controller

  alias Sso.{User, Email, Mailer}

  plug :scrub_params, "user" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [
        conn,
        conn.params,
        Guardian.Plug.current_resource(conn)
      ]
    )
  end

  def create(conn, %{"user" => user_params}, account) do
    user = Repo.get_by(User, email: user_params["email"])

    cond do
      user ->
        {:ok, user} =
          user
          |> User.gen_code_reset_changeset
          |> Repo.update

        location = User.gen_password_reset_link(user, user_params)
        account =
          account
          |> Repo.preload(:organization)

        Email.password_reset_email(user, account, location)
        |> Mailer.deliver_later

        send_resp conn, 201, ""
      true ->
        conn
        |> put_status(404)
        |> render(Sso.ErrorView, :"404", errors: %{message: "Email not found"})
    end
  end

  def update(conn, %{"id" => reset_code, "user" => reset_params}, _) do
    user = Repo.get_by(User, reset_code: reset_code)

    cond do
      user ->
        changeset = User.password_reset_changeset(user, reset_params)

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
        |> render(Sso.ErrorView, :"404", errors: %{message: "Reset code not found"})
    end
  end
end
