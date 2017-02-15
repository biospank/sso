defmodule Sso.Auth.Account do
  @moduledoc """
  Provides set of functions to authenticate.
  """
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  @realm "Dardy"

  def login(conn, account, opts \\ []) do
    conn = case opts do
      [ttl: expires] ->
        Guardian.Plug.api_sign_in(conn, account, :token, ttl: expires)
      _ ->
        Guardian.Plug.api_sign_in(conn, account)
    end

    conn
    |> set_authorization_header
    |> set_expire_header
  end

  def login_by_access_key_and_secret_key(conn, access_key, secret_key, opts) do
    repo = Keyword.fetch!(opts, :repo)
    account = repo.get_by(Sso.Account, access_key: access_key)

    cond do
      account && !account.active ->
        {:error, :locked, conn}
      account && checkpw(secret_key, account.secret_hash) ->
        {:ok, account, login(conn, account, opts)}
      account ->
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
