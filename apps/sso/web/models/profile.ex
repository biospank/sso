defmodule Sso.Profile do
  @moduledoc false
  use Sso.Web, :model

  # embedded_schema is short for:
  #
  #   @primary_key {:id, :binary_id, autogenerate: true}
  #   schema "embedded Item" do
  #
  embedded_schema do
    field :first_name
    field :last_name
    field :fiscal_code
    field :date_of_birth
    field :place_of_birth
    field :phone_number
    field :profession
    field :specialization
    field :board_member
    field :board_number
    field :province_board
    field :employment
    field :province_enployment
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
        :first_name,
        :last_name,
        :fiscal_code,
        :date_of_birth,
        :place_of_birth,
        :phone_number,
        :profession,
        :specialization,
        :board_member,
        :board_number,
        :province_board,
        :employment,
        :province_enployment
      ])
    |> validate_required([
        :first_name,
        :last_name,
        :fiscal_code,
        :date_of_birth,
        :place_of_birth,
        :phone_number,
        :profession,
        :specialization,
        :board_member,
        :board_number,
        :province_board,
        :employment,
        :province_enployment
      ])
  end
end
