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
      "Data registrazione", "Nome", "Cognome", "Email", "Attivo", "Stato",
      "Codice fiscale", "Data di Nascita", "Luogo di nascita",
      "Telefono", "Professione", "Specializzazione", "Attività lavorativa",
      "Consensi privacy", "Consenso comunicazioni", "Consenso raccolta dati"
    ]
  end

  defp csv_data(%Sso.User{inserted_at: registration_date, email: email, active: active, status: status, profile: profile}) do
    %{
      "Data registrazione" => "#{registration_date |> NaiveDateTime.to_erl |> Chronos.Formatter.strftime("%d/%m/%Y")}",
      "Nome" => "#{profile.first_name}", "Cognome" => "#{profile.last_name}",
      "Email" => "#{email}", "Attivo" => "#{active}", "Stato" => "#{status}",
      "Codice fiscale" => "#{profile.fiscal_code}",
      "Data di Nascita" => "#{profile.date_of_birth}",
      "Luogo di nascita" => "#{profile.place_of_birth}",
      "Telefono" => "#{profile.phone_number}", "Professione" => "#{profile.profession}",
      "Specializzazione" => "#{profile.specialization}",
      "Attività lavorativa" => "#{profile.employment}",
      "Consensi privacy" => "#{profile.app_consents |> Enum.join(", ")}",
      "Consenso comunicazioni" => "#{profile.news_consent}",
      "Consenso raccolta dati" => "#{profile.data_transfer_consent}"
    }
  end
end
