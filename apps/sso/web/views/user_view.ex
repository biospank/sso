defmodule Sso.UserView do
  use Sso.Web, :view

  def render("index.json", %{users: users}) do
    %{users: render_many(users, Sso.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{user: render_one(user, Sso.UserView, "user.json")}
  end

  def render("show_with_org_and_account.json", %{user: user}) do
    %{user: Map.merge(
        render_one(user, Sso.UserView, "user.json"),
        %{
          organization: render(Sso.OrganizationView, "organization.json", organization: user.organization),
          account: render(Sso.AccountView, "account.json", account: user.account)
        }
      )
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      active: user.active,
      status: user.status,
      profile: render(Sso.ProfileView, "profile.json", profile: user.profile)
    }
  end

  def render("user_with_org_and_account.json", %{user: user}) do
    Map.merge(
      render_one(user, Sso.UserView, "user.json"),
      %{
        organization: render(Sso.OrganizationView, "organization.json", organization: user.organization),
        account: render(Sso.AccountView, "account.json", account: user.account)
      }
    )
  end

  def render("paginated_users.json", %{page: page}) do
    %{
      users: render_many(page.entries, Sso.UserView, "user_with_org_and_account.json"),
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    }
  end

  def csv_content(users) do
    users
    |> Stream.map(&csv_data/1)
    |> CSV.encode(headers: csv_headers, separator: ?\t)
    |> Enum.to_list
    |> to_string
  end

  defp csv_headers() do
    [
      "Organizzazione", "App",
      "Data registrazione", "Nome", "Cognome", "Email", "Attivo", "Stato",
      "Codice fiscale", "Data di Nascita", "Luogo di nascita",
      "Telefono", "Professione", "Specializzazione", "Attività lavorativa",
      "Consensi privacy", "Consenso comunicazioni", "Consenso raccolta dati"
    ]
  end

  defp csv_data(user) do
    %{
      "Organizzazione" => user.organization.name, "App" => user.account.app_name,
      "Data registrazione" => "#{user.inserted_at |> NaiveDateTime.to_erl |> Chronos.Formatter.strftime("%d/%m/%Y")}",
      "Nome" => user.profile.first_name, "Cognome" => user.profile.last_name,
      "Email" => user.email, "Attivo" => user.active, "Stato" => user.status,
      "Codice fiscale" => user.profile.fiscal_code,
      "Data di Nascita" => user.profile.date_of_birth,
      "Luogo di nascita" => user.profile.place_of_birth,
      "Telefono" => user.profile.phone_number, "Professione" => user.profile.profession,
      "Specializzazione" => user.profile.specialization,
      "Attività lavorativa" => user.profile.employment,
      "Consensi privacy" => "#{user.profile.app_consents |> Enum.join(", ")}",
      "Consenso comunicazioni" => user.profile.news_consent,
      "Consenso raccolta dati" => user.profile.data_transfer_consent
    }
  end
end
