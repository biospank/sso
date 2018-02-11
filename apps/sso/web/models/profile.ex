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
    # |> cast_embed(:app_consents) we don't create app consents using params
  end

  def update_changeset(fields, params \\ %{}) do
    Organization.custom_fields(:data_value, fields)
    |> cast_update_changeset(Organization.custom_fields(:data_type, fields), params)
    |> validate_required(Organization.custom_fields(:required, fields) -- @optional_update_fields)
    # |> cast_embed(:app_consents) we don't update app consents using params
  end

  def clone_changeset(struct, profile) do
    struct
    |> changeset(Map.from_struct(profile))
    |> cast_embed(:app_consents, with: &Sso.Consent.clone_changeset/2)
  end

  def attrs_changeset(struct, attrs \\ %{}) do
    struct |> Ecto.Changeset.change(attrs)
  end

  # def add_app_consents(user_params, account) do
  #   if Map.has_key?(user_params, "profile") do
  #     put_in(user_params, ["profile", "app_consents"], [
  #         %{
  #           app_id: account.id,
  #           app_name: account.app_name,
  #           privacy: get_in(user_params, ["profile", "privacy_consent"])
  #         }
  #       ]
  #     )
  #   else
  #     user_params
  #   end
  # end

  def add_app_consents(user_changeset, %{"profile" => _}=user_params, account) do
    app_consents_changeset =
      user_changeset.changes.profile.data.app_consents # []
      |> Consent.update_app_consents_changeset(account, user_params["profile"])

    profile_changeset =
      user_changeset.changes.profile # Ecto.Changeset
      |> Ecto.Changeset.put_embed(:app_consents, app_consents_changeset)

    user_changeset
    |> Ecto.Changeset.put_embed(:profile, profile_changeset)
  end
  def add_app_consents(user_changeset, _, _) do
    user_changeset
  end
end
