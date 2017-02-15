defmodule Sso.User.SessionController do
  use Sso.Web, :controller

  alias Sso.Auth.User, as: Auth

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [
        conn,
        conn.params,
        Guardian.Plug.current_resource(conn)
      ]
    )
  end

  # to enable api versioning use the following syntax:
  # %{assigns: %{version: "v1"}}=conn, %{"user" => user_params}
  def create(conn, %{"user" => user_params}, account) do
    case Auth.login_by_email_and_password(
          conn,
          user_params["email"],
          user_params["password"],
          repo: Repo,
          account: account) do
      {:ok, user, authorized_conn} ->
        authorized_conn
        |> put_status(:created)
        |> render(Sso.UserView, "show.json", user: user)
      {:error, :not_found, conn} ->
        conn
        |> put_status(404)
        |> render(Sso.ErrorView, :"404", errors: %{message: "user not found"})
      {:error, :unauthorized, conn} ->
        conn
        |> put_status(401)
        |> render(Sso.ErrorView, :"401", errors: %{message: "user unauthorized"})
      {:error, :inactive, conn} ->
        conn
        |> put_status(423)
        |> render(Sso.ErrorView, :"423", errors: %{message: "user temporary disabled"})
      {:error, :unverified, conn} ->
        conn
        |> put_status(451)
        |> render(Sso.ErrorView, :"451", errors: %{message: "user not verified"})
    end
  end

  def delete(conn, %{"id" => _}, _) do
    send_resp(conn, :no_content, "")
  end
end
