defmodule Mix.Tasks.Sso.Account.New do
  use Mix.Task
  import Mix.Ecto
  import Ecto.Query

  alias Sso.{Crypto, Organization, Account, Repo}

  @shortdoc "Create new Sso account"

  @moduledoc """
  Generates access and secret key for Sso account and prints them to the terminal.
      mix sso.account.new
  """
  def run([name, app_name, ref_email]) do
    ensure_repo_running()

    org = Repo.one(from o in Organization, where: ilike(o.name, ^"%#{name}%"))

    if is_nil(org) do
      Mix.raise "No organization found with name #{name}"
    end

    access_key = Crypto.random_string(20)
    secret_key = Crypto.random_string(40)

    create_account(org, %{
      app_name: app_name,
      ref_email: ref_email,
      access_key: access_key,
      secret_key: secret_key
    })

    Mix.shell.info "Access Key: #{access_key}"
    Mix.shell.info "Secret Key: #{secret_key}"
  end
  def run(_), do: invalid_args!()

  defp ensure_repo_running do
    ensure_repo(Sso.Repo, [])
    ensure_started(Sso.Repo, [])
  end

  defp create_account(organization, params) do
    organization
    |> Ecto.build_assoc(:accounts)
    |> Account.registration_changeset(params)
    |> Repo.insert!
  end

  defp invalid_args! do
    Mix.raise """
      mix sso.account.new expects tree parameters:
      - organization name
      - app name
      - reference email (optional)
    """
  end
end
