defmodule Sso.Account do
  @moduledoc """
  Account model.
  """
  use Sso.Web, :model

  schema "accounts" do
    field :app_name, :string
    field :ref_email, :string
    field :access_key, :string
    field :secret_key, :string, virtual: true
    field :secret_hash, :string
    field :active, :boolean, default: true

    belongs_to :organization, Sso.Organization
    has_many :users, Sso.User

    timestamps()
  end

  defimpl Bamboo.Formatter, for: Sso.Account do
    # Used by `to`, `bcc`, `cc` and `from`
    def format_email_address(account, %{type: :from}) do
      {"Sso (inviato da #{account.organization.name})", account.ref_email || account.organization.ref_email}
    end

    def format_email_address(account, %{type: :to}) do
      account.ref_email || account.organization.ref_email
    end
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:app_name, :ref_email, :access_key, :secret_key, :active])
    |> validate_required([:app_name, :access_key, :secret_key, :active])
  end

  def registration_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> unique_constraint(:app_name, name: :accounts_app_name_organization_id_index)
    |> put_secret_hash()
  end

  defp put_secret_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{secret_key: secret_key}} ->
        put_change(changeset, :secret_hash, Comeonin.Bcrypt.hashpwsalt(secret_key))
      _ ->
        changeset
    end
  end
end
