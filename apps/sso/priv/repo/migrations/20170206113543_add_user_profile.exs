defmodule Sso.Repo.Migrations.AddUserProfile do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :profile, :map
    end
  end
end
