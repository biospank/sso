defmodule Sso.ArchivedUser do
  @moduledoc false
  use Sso.Web, :model

  schema "archived_users" do
    field :email, :string
    field :new_email
    field :password, :string, virtual: true
    field :new_password, :string, virtual: true
    field :password_hash, :string
    field :activation_code, :string
    field :reset_code, :string
    field :email_change_code, :string
    field :active, :boolean, read_after_writes: true
    field :status, StatusEnum, read_after_writes: true
    field :profile, :map

    belongs_to :user, Sso.User
    belongs_to :account, Sso.Account
    belongs_to :organization, Sso.Organization

    timestamps
  end

  # def changeset(user) do
  #   new_map =
  #     Map.from_struct(user)
  #     |> Map.merge(%{id: nil, account_id: nil, organization_id: nil})
  #
  #   struct(__MODULE__, new_map)
  #   |> Ecto.Changeset.change
  # end

  def clone_changeset(struct, user) do
    struct
    |> cast(Map.from_struct(user), [
      :email,
      :new_email,
      :password_hash,
      :activation_code,
      :reset_code,
      :email_change_code,
      :active,
      :status,
      :profile
    ])
  end
end
