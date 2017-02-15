defmodule Sso.OrganizationTest do
  use Sso.ModelCase

  alias Sso.Organization

  @valid_attrs %{name: "OrganizationName", ref_email: "test@organization.com"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Organization.changeset(%Organization{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Organization.changeset(%Organization{}, @invalid_attrs)
    refute changeset.valid?
  end
end
