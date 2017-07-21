defmodule Sso.User.PasswordResetController do
  use Sso.Web, :controller
  require Logger

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
    user = Repo.get_by(User, email: user_params["email"], organization_id: account.organization_id)

    cond do
      user ->
        {:ok, user} =
          user
          |> User.gen_crypto_code_changeset_for(:reset_code)
          |> Repo.update

        location = User.gen_password_reset_link(user, user_params)
        account =
          account
          |> Repo.preload(:organization)

        case Email.password_reset_email(user, account, location) do
          {:error, message} ->
            Logger.error message
          {:ok, email} ->
            Mailer.deliver_later(email)
        end

        send_resp conn, 201, ""
      true ->
        conn
        |> put_status(404)
        |> render(Sso.ErrorView, :"404", errors: %{message: gettext("Email not found")})
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
        |> render(Sso.ErrorView, :"404", errors: %{message: gettext("Reset code not found")})
    end
  end
end
