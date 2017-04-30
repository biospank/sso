defmodule Sso.ConsentTest do
  use Sso.ModelCase

  alias Sso.Consent

  @valid_attrs %{
    app_id: 1,
    app_name: "app name",
    privacy: true
  }

  test "changeset with valid attributes" do
    changeset = Consent.changeset(%Consent{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid app_id" do
    changeset = Consent.changeset(%Consent{}, Map.delete(@valid_attrs, :app_id))
    refute changeset.valid?
    assert changeset.errors == [app_id: {"can't be blank", [validation: :required]}]
  end

  test "changeset with invalid app_name" do
    changeset = Consent.changeset(%Consent{}, Map.delete(@valid_attrs, :app_name))
    refute changeset.valid?
    assert changeset.errors == [app_name: {"can't be blank", [validation: :required]}]
  end

  test "changeset with invalid privacy" do
    changeset = Consent.changeset(%Consent{}, Map.delete(@valid_attrs, :privacy))
    refute changeset.valid?
    assert changeset.errors == [privacy: {"can't be blank", [validation: :required]}]
  end
end
