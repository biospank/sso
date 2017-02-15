defmodule Sso.AccountTest do
  use Sso.ModelCase

  alias Sso.Account

  @valid_attrs %{
    app_name: "app name",
    ref_email: "test@example.com",
    access_key: "skkIInbIIhikIOJ",
    secret_key: "jsdjBuGHUGBGuHUBubNJbuBJBjHjNBBJbnjBNJ",
    active: true
  }
  @invalid_attrs %{}

  test "changeset with valid attributes is valid" do
    changeset = Account.changeset(%Account{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with missing app name is not valid" do
    changeset = Account.changeset(%Account{}, Map.delete(@valid_attrs, :app_name))
    refute changeset.valid?
    assert changeset.errors == [app_name: {"can't be blank", [validation: :required]}]
  end

  test "changeset with missing reference email is valid" do
    changeset = Account.changeset(%Account{}, Map.delete(@valid_attrs, :ref_email))
    assert changeset.valid?
  end

  test "changeset with missing access key is not valid" do
    changeset = Account.changeset(%Account{}, Map.delete(@valid_attrs, :access_key))
    refute changeset.valid?
    assert changeset.errors == [access_key: {"can't be blank", [validation: :required]}]
  end

  test "changeset with missing secrtet key is not valid" do
    changeset = Account.changeset(%Account{}, Map.delete(@valid_attrs, :secret_key))
    refute changeset.valid?
    assert changeset.errors == [secret_key: {"can't be blank", [validation: :required]}]
  end

  test "changeset with duplicate app name within the same organization scope is not valid" do
    org = insert_organization()
    insert_account(org)
    {:error, changeset} =
      %Account{}
      |> Account.registration_changeset(@valid_attrs)
      |> Ecto.Changeset.put_assoc(:organization, org)
      |> Repo.insert

    assert changeset.errors == [app_name: {"has already been taken", []}]
  end

  test "changeset with duplicate app name into different organization scope is valid" do
    org = insert_organization()
    insert_account(org)
    org1 = insert_organization(name: "org1")
    changeset =
      %Account{}
      |> Account.registration_changeset(@valid_attrs)
      |> Ecto.Changeset.put_assoc(:organization, org1)

    assert {:ok, _} = Repo.insert(changeset)
  end
end
