defmodule Backoffice.AccountController do
  use Backoffice.Web, :controller

  alias Sso.{Organization, Account, Repo, Crypto}

  plug :set_sso_locale

  def index(conn, params) do

    accounts = case Map.get(params, "org_id") do
      nil ->
        Sso.Repo.all(Sso.Account)
      org ->
        Sso.Repo.all(from Sso.Account, where: [organization_id: ^org])
    end

    render(conn, Sso.AccountView, "index.json", accounts: accounts)
  end

  def create(conn, %{"account" => account_params}) do
    organization = if(account_params["org_id"]) do
      Repo.get(Organization, account_params["org_id"])
    else
      %Organization{}
        |> Organization.registration_changeset(account_params["org"])
        |> Repo.insert!
    end

    [access_key, secret_key] = gen_keys

    account_changeset =
      organization
      |> Ecto.build_assoc(:accounts)
      |> Account.registration_changeset(Map.merge(account_params, %{"access_key" => access_key, "secret_key" => secret_key}))

    case Repo.insert(account_changeset) do
      {:ok, account} ->
        conn
        |> put_status(:created)
        |> render(Sso.AccountView, "show_with_credentials.json", account: account)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Sso.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp gen_keys do
    [Crypto.random_string(20), Crypto.random_string(40)]
  end

  defp set_sso_locale(conn, _) do
    Gettext.put_locale(Sso.Gettext, "it")

    conn
  end
end
