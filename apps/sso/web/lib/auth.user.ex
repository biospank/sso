defmodule Sso.Auth.User do
  @moduledoc """
  Provides set of functions to authenticate.
  """
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def login_by_email_and_password(conn, email, password, opts) do
    repo = Keyword.fetch!(opts, :repo)
    account = Keyword.fetch!(opts, :account)
    user =
      Sso.User
      |> repo.get_by(email: email)

    cond do
      user && !user.active ->
        {:error, :inactive, conn}
      user && user.status == :unverified ->
        {:error, :unverified, conn}
      user && user.organization_id != account.organization_id ->
        {:error, :not_found, conn}
      user && checkpw(password, user.password_hash) ->
        {:ok, user, conn}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end
end
