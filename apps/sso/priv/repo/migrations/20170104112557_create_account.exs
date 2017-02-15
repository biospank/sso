defmodule Sso.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :app_name, :string, unique: true
      add :ref_email, :string
      add :access_key, :string
      add :secret_hash, :string
      add :active, :boolean, default: true, null: false
      add :organization_id, references(:organizations, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:accounts, [:app_name, :organization_id])
    create index(:accounts, [:organization_id])
  end
end
