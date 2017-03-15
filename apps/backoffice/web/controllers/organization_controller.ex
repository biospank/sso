defmodule Backoffice.OrganizationController do
  use Backoffice.Web, :controller

  plug :scrub_params, "organization" when action in [:create]
  plug :set_locale

  def index(conn, _) do
    organizations = Sso.Repo.all(Sso.Organization)

    render(conn, Sso.OrganizationView, "index.json", organizations: organizations)
  end

  def create(conn, %{"organization" => organization_params}) do
    changeset = Sso.Organization.registration_changeset(%Sso.Organization{}, organization_params)

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

  defp set_locale(conn, _) do
    Gettext.put_locale(Sso.Gettext, "it")

    conn
  end
end
