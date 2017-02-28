defmodule Sso.SessionController do
  use Sso.Web, :controller

  alias Sso.Auth.Account, as: Auth

  # to enable api versioning use the following syntax:
  # %{assigns: %{version: "v1"}}=conn, %{"account" => account_params}
  def create(conn, %{"account" => account_params}) do
    case Auth.login_by_access_key_and_secret_key(
          conn,
          account_params["access_key"],
          account_params["secret_key"],
          repo: Repo,
          ttl: {1, :days}) do
      {:ok, account, authorized_conn} ->
        authorized_conn
        |> put_status(:created)
        |> render(Sso.AccountView, "show.json", account: account)
      {:error, :not_found, conn} ->
        conn
        |> put_status(404)
        |> render(Sso.ErrorView, :"404", errors: %{message: gettext("Account not found")})
      {:error, :unauthorized, conn} ->
        conn
        |> put_status(401)
        |> render(Sso.ErrorView, :"401", errors: %{message: gettext("Account unauthorized")})
      {:error, :locked, conn} ->
        conn
        |> put_status(423)
        |> render(Sso.ErrorView, :"423", errors: %{message: gettext("Account temporary disabled")})
    end
  end

  # def delete(conn, %{"id" => _}) do
  #   send_resp(conn, :no_content, "")
  # end
end
