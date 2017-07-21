defmodule Sso.Repo.Migrations.AddArchivedUsers do
  use Ecto.Migration

  def change do
    create table(:archived_users) do
      add :email, :string
      add :password_hash, :string
      add :activation_code, :string
      add :reset_code, :string
      add :email_change_code, :string
      add :new_email, :string
      add :active, :boolean, default: false
      add :status, :status, default: "unverified"
      add :user_id, references(:users, on_delete: :nothing)
      add :account_id, references(:accounts, on_delete: :nothing)
      add :organization_id, references(:organizations, on_delete: :nothing)
      add :profile, :map

      timestamps
    end

    create index(:archived_users, [:user_id])
    create index(:archived_users, [:account_id])
    create index(:archived_users, [:organization_id])

  end
end
