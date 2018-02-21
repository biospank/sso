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

  def update_app_consents(consents, account, %{"privacy_consent" => privacy_consent}) when privacy_consent in [true, "true", "1"] do
    case Enum.find_index(consents, fn(consent) -> consent["app_id"] == account.id end) do
      nil ->
        Enum.concat(consents, [create_new_consent(account, true)])
      idx ->
        List.update_at(consents, idx, &update_consent(&1, true))
    end
  end
  def update_app_consents(consents, _, _) do
    consents
  end

  defp create_new_consent(account, privacy_consent) do
    %{
      "app_id" => account.id,
      "app_name" => account.app_name,
      "privacy" => privacy_consent
    }
  end

  defp update_consent(consent, privacy_consent) do
    consent |> Map.put(:privacy, privacy_consent)
  end
end
