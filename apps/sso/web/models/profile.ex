defmodule Sso.Profile do
  @moduledoc false
  use Sso.Web, :model

  alias Sso.Organization
  alias Sso.Consent

  @optional_update_fields [
    :privacy_consent,
    :sso_privacy_consent
  ]

  def changeset(data_value, data_type, params \\ %{}) do
    {data_value, data_type}
    |> cast(params, Map.keys(data_type))
  end

  def cast_update_changeset(data_value, data_type, params \\ %{}) do
    {data_value, data_type}
    |> cast(params, (Map.keys(data_type) -- @optional_update_fields))
  end

  def registration_changeset(fields, params \\ %{}) do
    Organization.custom_fields(:data_value, fields)
    |> changeset(Organization.custom_fields(:data_type, fields), params)
    |> validate_required(Organization.custom_fields(:required, fields))
    |> validate_acceptance(:privacy_consent)
    |> validate_acceptance(:sso_privacy_consent)
  end

  def update_changeset(struct, fields, params) do
    update_params = struct |> Map.merge(params)

    Organization.custom_fields(:data_value, fields)
    |> cast_update_changeset(Organization.custom_fields(:data_type, fields), update_params)
    |> validate_required(Organization.custom_fields(:required, fields) -- @optional_update_fields)
  end

  def add_app_consents(profile, profile_params, account) do
    new_consents =
      (profile["app_consents"] || [])
      |> Consent.update_app_consents(account, profile_params)

    profile |> put_in(["app_consents"], new_consents)
  end
end
