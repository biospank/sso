defmodule Sso.PrivacyConsent do
  @moduledoc false
  use Sso.Web, :model


  embedded_schema do
    field :app_id, :integer
    field :app_name
    field :privacy, :boolean
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:app_id, :app_name, :privacy])
    |> validate_required([:app_id, :app_name, :privacy])
  end
end
