defmodule Backoffice.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:bo_users) do
      add :username, :string
      add :password_hash, :string

      timestamps()
    end
  end
end
