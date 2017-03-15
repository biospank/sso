defmodule Backoffice.AccountController do
  use Backoffice.Web, :controller

  alias Sso.{Organization, Account, Repo}

  def create(conn, %{"account" => account_params}) do
    IO.inspect(account_params)

    # if(account_params["org_id"]) do
    #   organization = Repo.get(Organization, account_params["org_id"])
    # else
    #   organization =
    #     %Organization{}
    #     |> Organization.registration_changeset(account_params["organization"])
    #     |> Repo.insert!
    # end
    #
    # organization
    # |> Ecto.build_assoc(:accounts)
    # |> Account.registration_changeset(account_params)
    # |> Repo.insert!

    account = %Sso.Account{
      id: 200,
      app_name: "test",
      access_key: "f0fjh30fjh0i3f03",
      secret_key: "HFUHFWEHF9EWHVCEHDOVCENOVDNBEOVNOENVOE",
      active: true
    }

    conn
    |> put_status(:created)
    |> render(Sso.AccountView, "show_with_credentials.json", account: account)
  end
end
