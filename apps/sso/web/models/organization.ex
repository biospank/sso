defmodule Sso.Organization do
  use Sso.Web, :model

  schema "organizations" do
    field :name, :string
    field :ref_email, :string
    field :settings, :map

    has_many :accounts, Sso.Account

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :ref_email, :settings])
    |> validate_required([:name, :ref_email])
  end

  def registration_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> unique_constraint(:name)
  end
end
