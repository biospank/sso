defmodule Sso.Repo.Migrations.AddOrganizationSettings do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      add :settings, :map
    end

    create index(:organizations, [:settings])

  end
end
