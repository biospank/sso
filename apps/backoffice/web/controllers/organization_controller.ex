defmodule Backoffice.OrganizationController do
  use Backoffice.Web, :controller

  def index(conn, _) do
    organizations = Sso.Repo.all(Sso.Organization)

    render(conn, Sso.OrganizationView, "index.json", organizations: organizations)
  end
end
