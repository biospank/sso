defmodule Backoffice.UserTest do
  use Backoffice.ModelCase

  alias Backoffice.User

  @valid_attrs %{
    username: "username",
    password: "secret"
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
end
