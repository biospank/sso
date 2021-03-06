defmodule Backoffice.OrganizationController do
  use Backoffice.Web, :controller

  plug :scrub_params, "organization" when action in [:create]
  plug :set_sso_locale

  def index(conn, _) do
    organizations = Sso.Repo.all(from o in Sso.Organization, order_by: o.name)

    render(conn, Sso.OrganizationView, "index.json", organizations: organizations)
  end

  def create(conn, %{"organization" => organization_params}) do
    changeset = Sso.Organization.registration_changeset(%Sso.Organization{}, organization_params)

    query = from o in Sso.Organization,
      where: ilike(o.name, ^organization_params["name"])

    changeset =
      case Sso.Repo.one(query) do
        nil ->
          changeset
        _ ->
          Ecto.Changeset.add_error(changeset, :name, "has already been taken")
      end

    case changeset.valid? do
      true ->
        conn
        |> put_status(:created)
        |> send_resp(201, "")
      false ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Sso.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => org_id, "organization" => organization_params}) do
    updated_organization = Sso.Organization
      |> Sso.Repo.get!(org_id)
      |> Sso.Organization.changeset(organization_params)
      |> Sso.Repo.update!

    render(conn, Sso.OrganizationView, "show.json", organization: updated_organization)
  end

  defp set_sso_locale(conn, _) do
    Gettext.put_locale(Sso.Gettext, "it")

    conn
  end
end
