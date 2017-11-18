defmodule Sso.User.ActivationController do
  use Sso.Web, :controller
  require Logger

  alias Sso.{User, Email, Mailer}

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [
        conn,
        conn.params,
        Guardian.Plug.current_resource(conn)
      ]
    )
  end

  def confirm(conn, %{"code" => activation_code}, account) do
    user = Repo.get_by(User, activation_code: activation_code)

    case user do
      nil ->
        conn
        |> put_status(404)
        |> render(Sso.ErrorView, :"404", errors: %{message: gettext("Activation code not found")})
      %User{active: true} ->
        conn
        |> put_status(304)
        |> render(Sso.ErrorView, :"304", errors: %{message: gettext("Not Modified")})
      user ->
        user = user
          |> Repo.preload(:organization)

        account = account
          |> Repo.preload(:organization)

        user_changeset = case get_in(user.organization.settings, ["email_template", "verification", "active"]) do
          value when value in [true, nil] ->
            Email.dardy_new_registration_template(user, account) |> Mailer.deliver_later
            User.activate_changeset(user)
          _ ->
            User.activate_and_authorize_changeset(user)
        end

        {:ok, user} = Repo.update(user_changeset)

        conn
        |> render(Sso.UserView, "show.json", user: user)
    end
  end

  def resend(conn, %{"user" => user_params}, account) do
    user = Repo.get_by(User, email: user_params["email"], organization_id: account.organization_id)

    case user do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(Sso.ErrorView, :"404", errors: %{message: gettext("Email not found")})
      user ->
        link = User.gen_activation_link(user, user_params)
        account =
          account
          |> Repo.preload(:organization)

        case Email.welcome_template(user, account, link) do
          {:error, message} ->
            Logger.error message
          {:ok, email} ->
            Mailer.deliver_later(email)
        end

        render(conn, Sso.UserView, "show.json", user: user)
    end
  end
end
