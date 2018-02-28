defmodule Sso.OrganizationTest do
  use Sso.ModelCase

  alias Sso.Organization

  @valid_attrs %{name: "OrganizationName", ref_email: "test@organization.com"}
  @invalid_attrs %{}

  @custom_fields [
    %{
      "id" => "1",
      "label" => "field 1",
      "name" => "field1",
      "data_type" => "string",
      "rule_type" => "optional",
      "default" => "",
      "customizable" => true
    },
    %{
      "id" => "2",
      "label" => "field 2",
      "name" => "field2",
      "data_type" => "string",
      "rule_type" => "optional",
      "default" => "field2 value",
      "customizable" => true
    },
    %{
      "id" => "3",
      "label" => "field 3",
      "name" => "field3",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => "",
      "customizable" => true
    },
    %{
      "id" => "4",
      "label" => "field 4",
      "name" => "field4",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => "",
      "customizable" => true
    }
  ]

  test "changeset with valid attributes" do
    changeset = Organization.changeset(%Organization{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Organization.changeset(%Organization{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "all custom fields" do
    assert Organization.custom_fields(:all, @custom_fields) == [:field1, :field2, :field3, :field4]
  end

  test "custom fields as a data type map" do
    assert Organization.custom_fields(:data_type, @custom_fields) == %{:field1 => :string, :field2 => :string, :field3 => :string, :field4 => :string}
  end

  test "custom fields as a default value map" do
    assert Organization.custom_fields(:data_value, @custom_fields) == %{:field1 => "", :field2 => "field2 value", :field3 => "", :field4 => ""}
  end

  test "required custom fields" do
    assert Organization.custom_fields(:required, @custom_fields) == [:field3, :field4]
  end

  test "optional custom fields" do
    assert Organization.custom_fields(:optional, @custom_fields) == [:field1, :field2]
  end

  test "custom field labels" do
    assert Organization.custom_fields(:label, @custom_fields) == ["field 1", "field 2", "field 3", "field 4"]
  end
end
