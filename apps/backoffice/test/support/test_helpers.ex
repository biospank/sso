defmodule Backoffice.TestHelpers do
  alias Backoffice.{Repo, User}

  def insert_bo_user(attrs \\ %{}) do
    changes = Map.merge(%{
      username: "admin",
      password: "secret",
      password_hash: Comeonin.Bcrypt.hashpwsalt("secret")
    }, attrs)

    %User{}
    |> Ecto.Changeset.change(changes)
    |> Repo.insert!

  end
end
