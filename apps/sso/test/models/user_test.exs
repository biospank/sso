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
      province_enployment: "Roma"
    }
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
end
