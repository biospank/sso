defmodule Sso.Profile do
  @moduledoc false
  use Sso.Web, :model

  alias Sso.PrivacyConsent

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
    field :privacy_consent, :boolean, virtual: true
    embeds_many :app_privacy_consents, PrivacyConsent
    field :sso_privacy_consent, :boolean
    field :province_enployment
  end

  @required_update_fields [
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
    # :employment,
    :sso_privacy_consent,
    :province_enployment
  ]

  @required_registration_fields @required_update_fields ++ [
    :privacy_consent
  ]

  @cast_fields @required_registration_fields ++ [
    :employment
  ]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @cast_fields)
  end

  def registration_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> validate_required(@required_registration_fields)
    |> cast_embed(:app_privacy_consents, required: true)
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> validate_required(@required_update_fields)
    |> cast_embed(:app_privacy_consents, required: true)
  end

  def add_app_privacy_consent(user_params, account) do
    if Map.has_key?(user_params, "profile") do
      put_in(user_params, ["profile", "app_privacy_consents"], [
          %{
            app_id: account.id,
            app_name: account.app_name,
            privacy: get_in(user_params, ["profile", "privacy_consent"])
          }
        ]
      )
    else
      user_params
    end
  end
end
