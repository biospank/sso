defmodule Mix.Tasks.Sso.Organization.List do
  use Mix.Task
  import Mix.Ecto

  alias Sso.{Organization, Repo}

  @shortdoc "List Sso organizations"

  @moduledoc """
  List all configured Sso Organization.
      mix sso.organization.list
  """
  def run(_) do
    ensure_repo_running()

    organizations = Repo.all(Organization)

    Mix.shell.info "Organization list:"
    for org <- organizations do
      Mix.shell.info "#{org.id} #{org.name} (#{org.ref_email})"
    end
  end

  defp ensure_repo_running do
    ensure_repo(Sso.Repo, [])
    ensure_started(Sso.Repo, [])
  end
end
