defmodule Backoffice.SessionController do
  use Backoffice.Web, :controller

  alias Backoffice.Auth.User, as: Auth

  def create(conn, %{"user" => user_params}) do
    opts = Keyword.new repo: Repo
    opts = case user_params["remember_me"] do
      true ->
        Keyword.merge(opts, ttl: { 7, :days })
      _ ->
        opts
    end

    case Auth.login_by_username_and_password(
          conn,
          user_params["username"],
          user_params["password"],
          opts) do
      {:ok, user, conn} ->
        conn
        |> put_status(:created)
        |> render(Backoffice.UserView, "show.json", user: user)
      {:error, :not_found, conn} ->
        conn
        |> put_status(404)
        |> render(Backoffice.ErrorView, :"404", errors: %{username: "Nome utente non valido"})
      {:error, :unauthorized, conn} ->
        conn
        |> put_status(401)
        |> render(Backoffice.ErrorView, :"401", errors: %{password: "Password non valida"})
    end
  end

  def delete(conn, %{"id" => _}) do
    send_resp(conn, :no_content, "")
  end
end
