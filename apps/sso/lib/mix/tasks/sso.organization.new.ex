defmodule Mix.Tasks.Sso.Organization.New do
  use Mix.Task
  import Mix.Ecto

  alias Sso.{Organization, Repo}

  @shortdoc "Create new Sso organization"

  @moduledoc """
  Create new Sso Organization.
      mix sso.organization.new
  """
  def run([name, ref_email]) do
    ensure_repo_running()

    org = create_organization(%{
      name: name,
      ref_email: ref_email
    })

    Mix.shell.info "A new organization has been created: #{org.id} - #{org.name}"
  end
  def run(_), do: invalid_args!()

  defp ensure_repo_running do
    ensure_repo(Sso.Repo, [])
    ensure_started(Sso.Repo, [])
  end

  defp create_organization(params) do
    %Organization{}
    |> Organization.registration_changeset(params)
    |> Repo.insert!
  end

  defp invalid_args! do
    Mix.raise """
      mix sso.organization.new expects two parameters:
      - organization name
      - reference email
    """
  end
end
