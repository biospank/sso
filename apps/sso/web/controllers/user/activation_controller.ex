defmodule Sso.User.ActivationController do
  use Sso.Web, :controller

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

  def confirm(conn, %{"code" => activation_code}, _) do
    user = Repo.get_by(User, activation_code: activation_code)

    cond do
      user ->
        {:ok, user} =
          user
          |> User.activation_changeset
          |> Repo.update

        conn
        |> render(Sso.UserView, "show.json", user: user)
      true ->
        conn
        |> put_status(404)
        |> render(Sso.ErrorView, :"404", errors: %{message: "Activation code not found"})
    end
  end

  def resend(conn, %{"user" => user_params}, account) do
    user = Repo.get_by(User, email: user_params["email"])

    case user do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(Sso.ErrorView, :"404", errors: %{message: "Email not found"})
      user ->
        link = User.gen_registration_link(user, user_params)
        account =
          account
          |> Repo.preload(:organization)

        Email.welcome_email(user, account, link) |> Mailer.deliver_later

        render(conn, Sso.UserView, "show.json", user: user)
    end
  end
end
