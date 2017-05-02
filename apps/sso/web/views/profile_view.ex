defmodule Sso.ProfileView do
  use Sso.Web, :view

  def render("profile.json", %{profile: profile}) do
    profile |> Map.delete(:privacy_consent)
  end
end
