alias Sso.{
  Repo,
  Organization,
  Account,
  User,
  Email,
  Mailer
}

setup = fn ->
  organization_changes = %{
    name: "name",
    ref_email: "test@example.com"
  }
  account_changes = %{
    app_name: "app name",
    access_key: "skkIInbIIhikIOJ",
    secret_key: "jsdjBuGHUGBGuHUBubNJbuBJBjHjNBBJbnjBNJ",
    active: true,
    status: 'verified'
  }

  org =
    %Organization{}
    |> Organization.registration_changeset(organization_changes)
    |> Repo.insert!

  account =
    org
    |> Ecto.build_assoc(:accounts)
    |> Account.registration_changeset(account_changes)
    |> Repo.insert!

  user_changes = %{
    email: "test@example.com",
    password: "secret",
    password_confirmation: "secret",
    activation_code: "_eoos7749wehhffdlnbbswiw883w7s",
    profile: %{
      "name" => "test profile",
      "phone" => "383893882"
    }
  }
  # user_profile = %{
  #   "name" => "test profile",
  #   "phone" => "383893882"
  # }

  user =
    account
    |> Ecto.build_assoc(:users)
    |> User.registration_changeset(user_changes)
    # |> Ecto.Changeset.put_embed(:profile, user_profile)
    |> Repo.insert!
end
