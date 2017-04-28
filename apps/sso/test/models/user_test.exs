defmodule Sso.UserTest do
  use Sso.ModelCase

  alias Sso.User

  @valid_attrs %{
    email: "test@example.com",
    password: "secret",
    password_confirmation: "secret",
    profile: %{
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
      app_privacy_consents: [
        %{
          app_id: 1,
          app_name: "app name",
          privacy: true
        }
      ],
      province_enployment: "Roma"
    }
  }

  @password_change_valid_attrs %{
    password: "secret",
    new_password: "secret123",
    new_password_confirmation: "secret123"
  }

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid email format" do
    changeset = User.changeset(%User{}, Map.put(@valid_attrs, :email, "invalid-email"))
    refute changeset.valid?
    assert changeset.errors[:email] == {"has invalid format", [validation: :format]}
  end

  test "registration changeset with short password" do
    changeset = User.registration_changeset(%User{}, Map.put(@valid_attrs, :password, "pwd"))
    refute changeset.valid?
    assert changeset.errors[:password] == {
      "should be at least %{count} character(s)",
      [count: 6, validation: :length, min: 6]
    }
  end

  test "registration changeset with invalid password confirmation" do
    changeset = User.registration_changeset(%User{}, Map.put(@valid_attrs, :password_confirmation, "another-secret"))
    refute changeset.valid?
    assert changeset.errors[:password_confirmation] == {
      "does not match password",
      [validation: :confirmation]
    }
  end

  test "registration changeset with empty password confirmation" do
    changeset = User.registration_changeset(%User{}, Map.put(@valid_attrs, :password_confirmation, ""))
    refute changeset.valid?
    assert changeset.errors[:password_confirmation] == {
      "does not match password",
      [validation: :confirmation]
    }
  end

  test "registration changeset with empty app privacy consents" do
    empty_app_privacy_consents = %{@valid_attrs | profile: %{@valid_attrs.profile | app_privacy_consents: []}}

    {:error, changeset} =
      User.registration_changeset(%User{}, empty_app_privacy_consents)
      |> Repo.insert # needed to validate embedded schema

    refute changeset.valid?

    assert changeset.changes.profile.errors[:app_privacy_consents] == {
      "can't be blank",
      [validation: :required]
    }
  end

  test "changeset with duplicate email within the same organization scope is not valid" do
    org = insert_organization()
    account = insert_account(org)
    insert_user(account)
    {:error, changeset} =
      %User{}
      |> User.registration_changeset(@valid_attrs)
      # |> Ecto.Changeset.put_assoc(:account, account)
      |> Ecto.Changeset.put_assoc(:organization, org)
      |> Repo.insert

    assert changeset.errors == [email: {"has already been taken", []}]
  end

  test "changeset with duplicate email into different organization scope is valid" do
    org = insert_organization()
    account = insert_account(org)
    insert_user(account)
    org1 = insert_organization(name: "org1")
    changeset =
      %User{}
      |> User.registration_changeset(@valid_attrs)
      |> Ecto.Changeset.put_assoc(:organization, org1)

    assert {:ok, _} = Repo.insert(changeset)
  end

  test "registration changeset with invalid profile" do
    changeset = User.registration_changeset(%User{}, Map.delete(@valid_attrs, :profile))
    refute changeset.valid?
    assert changeset.errors[:profile] == {"can't be blank", [validation: :required]}
  end

  test "password change changeset with valid attributes" do
    changeset = User.password_change_changeset(%User{}, @password_change_valid_attrs)
    assert changeset.valid?
  end

  test "password change changeset without new password" do
    changeset = User.password_change_changeset(%User{}, Map.delete(@password_change_valid_attrs, :new_password))
    refute changeset.valid?
  end

  test "password change changeset with invalid new password" do
    changeset = User.password_change_changeset(%User{}, Map.merge(@password_change_valid_attrs, %{new_password: "pwd"}))
    refute changeset.valid?
  end

  test "password change changeset with unmatched new password confimation" do
    changeset = User.password_change_changeset(%User{}, Map.merge(@password_change_valid_attrs, %{new_password_confirmation: "invalid"}))
    refute changeset.valid?
  end
end
