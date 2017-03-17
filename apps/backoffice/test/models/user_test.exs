defmodule Backoffice.UserTest do
  use Backoffice.ModelCase

  alias Backoffice.User

  @valid_attrs %{
    username: "username",
    password: "secret",
    new_password: "secret123",
    new_password_confirmation: "secret123"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "password changeset with valid attributes" do
    changeset = User.password_changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "password changeset without new password" do
    changeset = User.password_changeset(%User{}, Map.delete(@valid_attrs, :new_password))
    refute changeset.valid?
  end

  test "password changeset with invalid new password" do
    changeset = User.password_changeset(%User{}, Map.merge(@valid_attrs, %{new_password: "pwd"}))
    refute changeset.valid?
  end

  test "password changeset with unmatched new password confimation" do
    changeset = User.password_changeset(%User{}, Map.merge(@valid_attrs, %{new_password_confirmation: "invalid"}))
    refute changeset.valid?
  end
end
