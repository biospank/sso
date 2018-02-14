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

  def custom_fields(rule, fields \\ [])
  def custom_fields(rule, fields) when rule == :all do
    Enum.map(fields, &(&1["name"] |> String.to_atom))
  end
  def custom_fields(rule, fields) when rule == :data_value do
    Map.new(fields, fn field ->
      {field["name"] |> String.to_atom, field |> to_value}
    end)
  end
  def custom_fields(rule, fields) when rule == :data_type do
    Map.new(fields, fn field ->
      {field["name"] |> String.to_atom, field["data_type"] |> String.to_atom}
    end)
  end
  def custom_fields(rule, fields) do
    field_rule = Atom.to_string(rule)

    Enum.filter_map(fields, fn(field) ->
      field["rule_type"] == field_rule
    end, &(&1["name"] |> String.to_atom))
  end

  defp to_value(field) do
    case field["data_type"] do
      "boolean" ->
        String.to_existing_atom(field["default"])
      _ ->
        field["default"]
    end
  end
end
