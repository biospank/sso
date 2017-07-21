defmodule Sso.Repo.Migrations.AddUserChangeCode do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :email_change_code, :string
      add :new_email, :string
    end
  end
end
