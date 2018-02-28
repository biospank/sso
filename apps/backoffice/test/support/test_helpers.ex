defmodule Backoffice.TestHelpers do
  alias Backoffice.{Repo, User}
  alias Sso.Organization

  def insert_bo_user(attrs \\ %{}) do
    changes = Map.merge(%{
      username: "admin",
      password: "secret",
      password_hash: Comeonin.Bcrypt.hashpwsalt("secret")
    }, attrs)

    %User{}
    |> Ecto.Changeset.change(changes)
    |> Repo.insert!

  end

  def insert_bo_organization(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "name",
      ref_email: "test@example.com",
      settings: %{
        custom_fields: [
          %{
            id: "1",
            label: "field 1",
            name: "first_name",
            data_type: "string",
            rule_type: "required",
            default: "",
            customizable: "true"
          },
          %{
            id: "2",
            label: "Last name",
            name: "last_name",
            data_type: "string",
            rule_type: "required",
            default: "",
            customizable: "true"
          },
          %{
            id: "3",
            label: "Fiscal code",
            name: "fiscal_code",
            data_type: "string",
            rule_type: "required",
            default: "",
            customizable: "true"
          },
          %{
            id: "4",
            label: "Date of birth",
            name: "date_of_birth",
            data_type: "string",
            rule_type: "required",
            default: "",
            customizable: "true"
          },
          %{
            id: "5",
            label: "Place of birth",
            name: "place_of_birth",
            data_type: "string",
            rule_type: "required",
            default: "",
            customizable: "true"
          },
          %{
            id: "6",
            label: "Phone number",
            name: "phone_number",
            data_type: "string",
            rule_type: "required",
            default: "",
            customizable: "true"
          },
          %{
            id: "7",
            label: "Profession",
            name: "profession",
            data_type: "string",
            rule_type: "required",
            default: "",
            customizable: "true"
          },
          %{
            id: "8",
            label: "Specialization",
            name: "specialization",
            data_type: "string",
            rule_type: "required",
            default: "",
            customizable: "true"
          },
          %{
            id: "9",
            label: "Board member",
            name: "board_member",
            data_type: "string",
            rule_type: "required",
            default: "",
            customizable: "true"
          },
          %{
            id: "10",
            label: "Board number",
            name: "board_number",
            data_type: "string",
            rule_type: "required",
            default: "",
            customizable: "true"
          },
          %{
            id: "11",
            label: "Province board",
            name: "province_board",
            data_type: "string",
            rule_type: "required",
            default: "",
            customizable: "true"
          },
          %{
            id: "12",
            label: "Enployment",
            name: "enployment",
            data_type: "string",
            rule_type: "optional",
            default: "",
            customizable: "true"
          },
          %{
            id: "13",
            label: "Province enployment",
            name: "province_enployment",
            data_type: "string",
            rule_type: "required",
            default: "",
            customizable: "true"
          },
          %{
            id: "14",
            label: "Privacy consent",
            name: "privacy_consent",
            data_type: "boolean",
            rule_type: "required",
            default: "false",
            customizable: "false"
          },
          %{
            id: "15",
            label: "Sso privacy consent",
            name: "sso_privacy_consent",
            data_type: "boolean",
            rule_type: "required",
            default: "false",
            customizable: "false"
          },
          %{
            id: "16",
            label: "News consent",
            name: "news_consent",
            data_type: "boolean",
            rule_type: "optional",
            default: "false",
            customizable: "true"
          },
          %{
            id: "17",
            label: "Data transfer consent",
            name: "data_transfer_consent",
            data_type: "boolean",
            rule_type: "optional",
            default: "false",
            customizable: "true"
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
end
