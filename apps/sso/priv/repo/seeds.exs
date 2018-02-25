# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Sso.Repo.insert!(%Sso.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Sso.{Crypto, Repo, Organization}

org =
  %Organization{}
  |> Ecto.Changeset.change(%{
      name: Faker.Company.name,
      ref_email: Faker.Internet.email
    })
  |> Repo.insert!

access_key = Crypto.random_string(20)
secret_key = Crypto.random_string(40)

account = org
  |> Ecto.build_assoc(:accounts)
  |> Ecto.Changeset.change(%{
      app_name: Faker.App.name,
      access_key: access_key,
      secret_key: secret_key,
      secret_hash: Comeonin.Bcrypt.hashpwsalt(secret_key),
      active: true
    })
  |> Repo.insert!

for n <- 1..120 do
  profile = %{
    first_name: Faker.Name.first_name,
    last_name: Faker.Name.last_name,
    fiscal_code: Faker.Code.isbn13,
    date_of_birth: "1997-02-12",
    place_of_birth: Faker.Address.city,
    phone_number: Faker.Phone.EnGb.cell_number,
    profession: Faker.Name.title,
    specialization: Faker.Company.buzzword_prefix,
    board_member: Faker.Company.buzzword_prefix,
    board_number: Faker.Phone.EnUs.subscriber_number,
    province_board: Faker.Address.city,
    enployment: Faker.Team.En.name,
    province_enployment: Faker.Address.city,
    sso_privacy_consent: true,
    privacy_consent: true,
    app_consents: []
  }

  password = Faker.Internet.user_name

  account
    |> Ecto.build_assoc(:users, %{organization_id: account.organization_id})
    |> Ecto.Changeset.change(%{
        email: Faker.Internet.email,
        password: password,
        password_hash: Comeonin.Bcrypt.hashpwsalt(password),
        activation_code: Crypto.random_string(32)
      })
    |> Ecto.Changeset.put_change(:profile, profile)
    |> Repo.insert!
end
