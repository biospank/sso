defmodule Sso.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def up do
    StatusEnum.create_type

    create table(:users) do
      add :email, :string
      add :password_hash, :string
      add :activation_code, :string
      add :reset_code, :string
      add :active, :boolean, default: false
      add :status, :status, default: "unverified"
      add :account_id, references(:accounts, on_delete: :nothing)
      add :organization_id, references(:organizations, on_delete: :nothing)

      timestamps
    end

    create unique_index(:users, [:email, :organization_id])
    create index(:users, [:account_id])
    create index(:users, [:organization_id])

  end

  def down do
    drop table(:users)
    StatusEnum.drop_type
  end
end
