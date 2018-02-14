defmodule Sso.TestHelpers do
  alias Sso.{Repo, Organization}

  def insert_organization(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "name",
      ref_email: "test@example.com",
      settings: %{
        "custom_fields" => [
          %{
            "name" => "first_name",
            "data_type" => "string",
            "rule_type" => "required",
            "default" => ""
          },
          %{
            "name" => "last_name",
            "data_type" => "string",
            "rule_type" => "required",
            "default" => ""
          },
          %{
            "name" => "fiscal_code",
            "data_type" => "string",
            "rule_type" => "required",
            "default" => ""
          },
          %{
            "name" => "date_of_birth",
            "data_type" => "string",
            "rule_type" => "required",
            "default" => ""
          },
          %{
            "name" => "place_of_birth",
            "data_type" => "string",
            "rule_type" => "required",
            "default" => ""
          },
          %{
            "name" => "phone_number",
            "data_type" => "string",
            "rule_type" => "required",
            "default" => ""
          },
          %{
            "name" => "profession",
            "data_type" => "string",
            "rule_type" => "required",
            "default" => ""
          },
          %{
            "name" => "specialization",
            "data_type" => "string",
            "rule_type" => "required",
            "default" => ""
          },
          %{
            "name" => "board_member",
            "data_type" => "string",
            "rule_type" => "required",
            "default" => ""
          },
          %{
            "name" => "board_number",
            "data_type" => "string",
            "rule_type" => "required",
            "default" => ""
          },
          %{
            "name" => "province_board",
            "data_type" => "string",
            "rule_type" => "required",
            "default" => ""
          },
          %{
            "name" => "employment",
            "data_type" => "string",
            "rule_type" => "optional",
            "default" => ""
          },
          %{
            "name" => "province_enployment",
            "data_type" => "string",
            "rule_type" => "required",
            "default" => ""
          },
          %{
            "name" => "privacy_consent",
            "data_type" => "boolean",
            "rule_type" => "required",
            "default" => "false"
          },
          %{
            "name" => "sso_privacy_consent",
            "data_type" => "boolean",
            "rule_type" => "required",
            "default" => "false"
          },
          %{
            "name" => "news_consent",
            "data_type" => "boolean",
            "rule_type" => "optional",
            "default" => "false"
          },
          %{
            "name" => "data_transfer_consent",
            "data_type" => "boolean",
            "rule_type" => "optional",
            "default" => "false"
          }
        ],
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
          reminder: %{
            active: true,
            subject: "app name - Conferma registrazione",
            html_body: "Gentile first name last name"
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
          },
          email_change: %{
            subject: "app name - Cambio mail",
            web: %{
              html_body: "Gentile first name last name http://anysite.com/resetpwd?code=<%= user.email_change_code %>"
            },
            mobile: %{
              html_body: "Gentile first name last name <%= user.email_change_code %>"
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
      privacy_consent: true,
      province_enployment: "Roma",
      app_consents: %{
        app_id: account.id,
        app_name: account.app_name,
        privacy: true
      }
    }, attrs["profile"] || %{})

    account
    |> Ecto.build_assoc(:users, %{organization_id: account.organization_id})
    |> Ecto.Changeset.change(changes)
    |> Ecto.Changeset.put_change(:profile, profile)
    |> Repo.insert!
  end
end
