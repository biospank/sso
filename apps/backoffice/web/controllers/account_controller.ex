defmodule Backoffice.AccountController do
  use Backoffice.Web, :controller

  alias Sso.{Organization, Account, Repo, Crypto}

  plug :set_locale

  def create(conn, %{"account" => account_params}) do
    IO.inspect(account_params)

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
        |> render(Sso.AccountView, "show_with_credentials.json", account: account, secret_key: secret_key)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Sso.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp gen_keys do
    [Crypto.random_string(20), Crypto.random_string(40)]
  end

  defp set_locale(conn, _) do
    Gettext.put_locale(Sso.Gettext, "it")

    conn
  end
end
