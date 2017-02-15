defmodule Sso.Repo.Migrations.CreateOrganization do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string
      add :ref_email, :string, null: false

      timestamps()
    end

    create unique_index(:organizations, [:name])

  end
end
