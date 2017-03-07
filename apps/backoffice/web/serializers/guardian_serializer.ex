defmodule Backoffice.GuardianSerializer do
  @moduledoc """
  Provides Guardian callback functions.
  """
  alias Backoffice.{Repo, User}

  def for_token(user = %User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Unknown resource for backoffice"}
  def from_token("User:" <> id), do: {:ok, Repo.get(User, id)}
  def from_token(_), do: {:error, "Unknown token"}
end
