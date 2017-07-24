defmodule Sso.Consent do
  @moduledoc false
  use Sso.Web, :model


  embedded_schema do
    field :app_id, :integer
    field :app_name
    field :privacy, :boolean
  end

  defimpl(String.Chars, for: Sso.Consent) do
    def to_string(consent) do
      consent.app_name
    end
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:app_id, :app_name, :privacy])
    |> validate_required([:app_id, :app_name, :privacy])
  end

  # consent_changeset = %Sso.Consent{} |> Sso.Consent.changeset(%{app_id: 20, app_name: "franco", privacy: true})
  # changeset = user.profile |> Sso.Profile.update_changeset |> Ecto.Changeset.put_embed(:app_consents, [consent_changeset])

  def update_app_consents_changeset(struct, account, %{"privacy_consent" => privacy_consent}) when privacy_consent in [true, "true", "1"] do
    case Enum.find_index(struct, fn(item) -> item.app_id == account.id end) do
      nil ->
        Enum.concat(struct, [create_new_consent(account, true)])
      idx ->
        List.update_at(struct, idx, &update_consent(&1, true))
    end
  end
  def update_app_consents_changeset(struct, _, _) do
    struct
  end

  def clone_changeset(struct, consent) do
    struct
    |> changeset(Map.from_struct(consent))
  end

  defp create_new_consent(account, privacy_consent) do
    %__MODULE__{}
    |> changeset(%{
      app_id: account.id,
      app_name: account.app_name,
      privacy: privacy_consent
    })
  end

  defp update_consent(item, privacy_consent) do
    item
    |> changeset(%{
      privacy: privacy_consent
    })
  end
end
