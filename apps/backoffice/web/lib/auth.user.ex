defmodule Backoffice.Auth.User do
  @moduledoc """
  Provides set of functions to authenticate.
  """
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  @realm "Dardy"

  def login(conn, user, opts \\ []) do
    conn = case opts do
      [ttl: expires] ->
        Guardian.Plug.api_sign_in(conn, user, :token, ttl: expires)
      _ ->
        Guardian.Plug.api_sign_in(conn, user)
    end

    conn
    |> set_authorization_header
    |> set_expire_header
  end

  def login_by_username_and_password(conn, username, password, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(Backoffice.User, username: username)

    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, user, login(conn, user, opts)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  defp set_authorization_header(conn) do
    jwt = Guardian.Plug.current_token(conn)
    Plug.Conn.put_resp_header(conn, "authorization", "#{@realm} #{jwt}")
  end

  defp set_expire_header(conn) do
    {:ok, claims} = Guardian.Plug.claims(conn)
    exp = Map.get(claims, "exp")

    Plug.Conn.put_resp_header(conn, "x-expires", "#{exp}")
  end
end
