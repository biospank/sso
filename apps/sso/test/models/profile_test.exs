defmodule Sso.ProfileTest do
  use Sso.ModelCase

  alias Sso.Profile

  @valid_attrs %{
    "first_name" => "first name",
    "last_name" => "last name",
    "fiscal_code" => "ggrsta21s50h501z",
    "date_of_birth" => "1997-02-12",
    "place_of_birth" => "Roma",
    "phone_number" => "227726622",
    "profession" => "Medico generico",
    "specialization" => "Pediatria",
    "board_member" => "Medici",
    "board_number" => "3773662882",
    "province_board" => "Roma",
    "employment" => "Medico generico",
    "privacy_consent" => true,
    "sso_privacy_consent" => true,
    "news_consent" => true,
    "data_transfer_consent" => true,
    "province_enployment" => "Roma"
  }
  @custom_fields [
    %{
      "id" => "1",
      "label" => "First name",
      "name" => "first_name",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => "",
      "customizable" => true
    },
    %{
      "id" => "2",
      "label" => "Last name",
      "name" => "last_name",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => "",
      "customizable" => true
    },
    %{
      "id" => "3",
      "label" => "Fiscal code",
      "name" => "fiscal_code",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => "",
      "customizable" => true
    },
    %{
      "id" => "4",
      "label" => "Date of birth",
      "name" => "date_of_birth",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => "",
      "customizable" => true
    },
    %{
      "id" => "5",
      "label" => "Place of birth",
      "name" => "place_of_birth",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => "",
      "customizable" => true
    },
    %{
      "id" => "6",
      "label" => "Phone number",
      "name" => "phone_number",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => "",
      "customizable" => true
    },
    %{
      "id" => "7",
      "label" => "Profession",
      "name" => "profession",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => "",
      "customizable" => true
    },
    %{
      "id" => "8",
      "label" => "Specialization",
      "name" => "specialization",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => "",
      "customizable" => true
    },
    %{
      "id" => "9",
      "label" => "Board member",
      "name" => "board_member",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => "",
      "customizable" => true
    },
    %{
      "id" => "10",
      "label" => "Board number",
      "name" => "board_number",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => "",
      "customizable" => true
    },
    %{
      "id" => "11",
      "label" => "Province board",
      "name" => "province_board",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => "",
      "customizable" => true
    },
    %{
      "id" => "12",
      "label" => "Enployment",
      "name" => "enployment",
      "data_type" => "string",
      "rule_type" => "optional",
      "default" => "",
      "customizable" => true
    },
    %{
      "id" => "13",
      "label" => "Province enployment",
      "name" => "province_enployment",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => "",
      "customizable" => true
    },
    %{
      "id" => "14",
      "label" => "Privacy consent",
      "name" => "privacy_consent",
      "data_type" => "boolean",
      "rule_type" => "required",
      "default" => "false",
      "customizable" => false
    },
    %{
      "id" => "15",
      "label" => "Sso privacy consent",
      "name" => "sso_privacy_consent",
      "data_type" => "boolean",
      "rule_type" => "required",
      "default" => "false",
      "customizable" => false
    },
    %{
      "id" => "16",
      "label" => "News consent",
      "name" => "news_consent",
      "data_type" => "boolean",
      "rule_type" => "optional",
      "default" => "false",
      "customizable" => true
    },
    %{
      "id" => "17",
      "label" => "Data transfer consent",
      "name" => "data_transfer_consent",
      "data_type" => "boolean",
      "rule_type" => "optional",
      "default" => "false",
      "customizable" => true
    }
  ]

  test "registration changeset with valid attributes" do
    changeset = Profile.registration_changeset(@custom_fields, @valid_attrs)
    assert changeset.valid?
  end

  test "registration changeset with missing privacy consent" do
    changeset = Profile.registration_changeset(@custom_fields, Map.delete(@valid_attrs, "privacy_consent"))
    refute changeset.valid?
    assert changeset.errors[:privacy_consent] == {"must be accepted", [validation: :acceptance]}
  end

  test "registration changeset with invalid privacy consent" do
    changeset = Profile.registration_changeset(@custom_fields, Map.put(@valid_attrs, "privacy_consent", false))
    refute changeset.valid?
    assert changeset.errors[:privacy_consent] == {"must be accepted", [validation: :acceptance]}
  end

  test "registration changeset with missing sso privacy consent" do
    changeset = Profile.registration_changeset(@custom_fields, Map.delete(@valid_attrs, "sso_privacy_consent"))
    refute changeset.valid?
    assert changeset.errors[:sso_privacy_consent] == {"must be accepted", [validation: :acceptance]}
  end

  test "registration changeset with invalid sso privacy consent" do
    changeset = Profile.registration_changeset(@custom_fields, Map.put(@valid_attrs, "sso_privacy_consent", false))
    refute changeset.valid?
    assert changeset.errors[:sso_privacy_consent] == {"must be accepted", [validation: :acceptance]}
  end

  test "registration changeset with missing news consent" do
    changeset = Profile.registration_changeset(@custom_fields, Map.delete(@valid_attrs, "news_consent"))

    assert changeset.valid?
    profile = Ecto.Changeset.apply_changes(changeset)
    assert profile.news_consent == false
  end

  test "registration changeset with missing data transfer consent" do
    changeset = Profile.registration_changeset(@custom_fields, Map.delete(@valid_attrs, "data_transfer_consent"))

    assert changeset.valid?
    profile = Ecto.Changeset.apply_changes(changeset)
    assert profile.data_transfer_consent == false
  end

  test "update changeset with missing privacy consent" do
    changeset = Profile.update_changeset(
      @valid_attrs,
      @custom_fields,
      Map.delete(@valid_attrs, "privacy_consent")
    )

    assert changeset.valid?
  end

  test "update changeset with invalid sso privacy consent" do
    changeset = Profile.update_changeset(
      @valid_attrs,
      @custom_fields,
      Map.put(@valid_attrs, "sso_privacy_consent", false)
    )

    assert changeset.valid?
  end

  test "registration changeset with invalid required fields" do
    Enum.each([
      "first_name", "last_name", "fiscal_code", "date_of_birth", "place_of_birth",
      "phone_number", "profession", "specialization", "board_member", "board_number",
      "province_board", "province_enployment" #, "employment",
    ], fn field ->
      changeset = Profile.registration_changeset(@custom_fields, Map.delete(@valid_attrs, field))
      refute changeset.valid?
      assert changeset.errors[String.to_atom(field)] == {"can't be blank", [validation: :required]}
    end)
  end

  test "update changeset with invalid required fields" do
    Enum.each([
      "first_name", "last_name", "fiscal_code", "date_of_birth", "place_of_birth",
      "phone_number", "profession", "specialization", "board_member", "board_number",
      "province_board", "province_enployment" #, "employment",
    ], fn field ->
      changeset = Profile.update_changeset(
        @valid_attrs,
        @custom_fields,
        Map.put(@valid_attrs, field, "")
      )

      refute changeset.valid?
      assert changeset.errors[String.to_atom(field)] == {"can't be blank", [validation: :required]}
    end)
  end

  test "add app consents" do
    account = %Sso.Account{
      id: 123,
      app_name: "app name"
    }

    profile_data =
      @custom_fields
      |> Profile.registration_changeset(@valid_attrs)
      |> Ecto.Changeset.apply_changes
      |> Profile.add_app_consents(@valid_attrs, account)

    refute profile_data["app_consents"] |> Enum.empty?
  end
end
