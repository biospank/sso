defmodule Sso.Repo.Migrations.AddIsertedAtUserIndex do
  use Ecto.Migration

  def change do
    create index(:users, [:inserted_at])
  end
end
