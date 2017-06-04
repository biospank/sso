defmodule Sso.TestHelpers do
  alias Sso.{Repo, Organization}

  def insert_organization(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "name",
      ref_email: "test@example.com",
      settings: %{
        email_template: %{
          registration: %{
            subject: "app name - Richiesta registrazione",
            web: %{
              html_body: "Gentile first name last name http://anysite.com/opt-in?code=<%= user.activation_code %>"
            },
            mobile: %{
              html_body: "Gentile first name last name <%= user.activation_code %>"
            }
          },
          verification: %{
            subject: "app name - Conferma registrazione",
            html_body: "Gentile first name last name"
          },
          password_reset: %{
            subject: "app name - Recupera password",
            web: %{
              html_body: "Gentile first name last name http://anysite.com/resetpwd?code=<%= user.reset_code %>"
            },
            mobile: %{
              html_body: "Gentile first name last name <%= user.reset_code %>"
            }
          }
        }
      }
    }, attrs)

    %Organization{}
    |> Ecto.Changeset.change(changes)
    |> Repo.insert!
  end

  def insert_account(organization, attrs \\ %{}) do
    changes = Dict.merge(%{
      app_name: "app name",
      access_key: "skkIInbIIhikIOJ",
      secret_key: "jsdjBuGHUGBGuHUBubNJbuBJBjHjNBBJbnjBNJ",
      secret_hash: Comeonin.Bcrypt.hashpwsalt("jsdjBuGHUGBGuHUBubNJbuBJBjHjNBBJbnjBNJ"),
      active: true
    }, attrs)

    organization
    |> Ecto.build_assoc(:accounts)
    |> Ecto.Changeset.change(changes)
    |> Repo.insert!
  end

  def insert_user(account, attrs \\ %{}) do
    changes = Map.merge(%{
      email: "test@example.com",
      password: "secret",
      password_hash: Comeonin.Bcrypt.hashpwsalt("secret"),
      activation_code: "_eoos7749wehhffdlnbbswiw883w7s"
    }, attrs)

    profile = Map.merge(%{
      first_name: "first name",
      last_name: "last name",
      fiscal_code: "ggrsta21s50h501z",
      date_of_birth: "1997-02-12",
      place_of_birth: "Roma",
      phone_number: "227726622",
      profession: "Medico generico",
      specialization: "Pediatria",
      board_member: "Medici",
      board_number: "3773662882",
      province_board: "Roma",
      employment: "Medico generico",
      sso_privacy_consent: true,
      privacy_consent: false,
      province_enployment: "Roma"
    }, attrs["profile"] || %{})

    account
    |> Ecto.build_assoc(:users, %{organization_id: account.organization_id})
    |> Ecto.Changeset.change(changes)
    |> Ecto.Changeset.put_embed(:profile, profile)
    |> Repo.insert!
  end
end
