defmodule Auth.Serializers.GuardianSerializer do
  @moduledoc """
  Provides Guardian callback functions.
  """
  def for_token(account = %Sso.Account{}), do: {:ok, "Account:#{account.id}"}
  def for_token(user = %Backoffice.User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}
  def from_token("Account:" <> id), do: {:ok, Sso.Repo.get(Sso.Account, id)}
  def from_token("User:" <> id), do: {:ok, Backoffice.Repo.get(Backoffice.User, id)}
  def from_token(_), do: {:error, "Unknown token"}
end
