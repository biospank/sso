defmodule SsoBo.SessionController do
  use SsoBo.Web, :controller

  alias SsoBo.Auth.Backoffice, as: Auth

  # insert an new bo_users
  # %SsoBo.User{} |> Ecto.Changeset.change(username: "admin", password_hash: Comeonin.Bcrypt.hashpwsalt("Backoffice_001")) |> SsoBo.Repo.insert!

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
      {:ok, user, _} ->
        conn = case user_params["remember_me"] do
          true ->
            Auth.login(conn, user, ttl: { 7, :days })
          false ->
            Auth.login(conn, user)
        end

        conn
        |> put_status(:created)
        |> render(SsoBo.UserView, "show.json", user: user)
      {:error, :not_found, conn} ->
        conn
        |> put_status(404)
        |> render(SsoBo.ErrorView, :"404", errors: %{username: "Nome utente non valido"})
      {:error, :unauthorized, conn} ->
        conn
        |> put_status(401)
        |> render(SsoBo.ErrorView, :"401", errors: %{password: "Password non valida"})
    end
  end

  def delete(conn, %{"id" => _}) do
    send_resp(conn, :no_content, "")
  end
end
