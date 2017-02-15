defmodule Sso.OrganizationView do
  use Sso.Web, :view

  def render("index.json", %{organization: organization}) do
    %{organizations: render_many(organization, Sso.OrganizationView, "organization.json")}
  end

  def render("show.json", %{organization: organization}) do
    %{organization: render_one(organization, Sso.OrganizationView, "organization.json")}
  end

  def render("organization.json", %{organization: organization}) do
    %{
      id: organization.id,
      name: organization.name,
      ref_email: organization.ref_email
    }
  end
end
