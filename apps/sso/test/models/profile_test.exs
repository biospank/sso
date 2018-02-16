defmodule Sso.ProfileTest do
  use Sso.ModelCase

  alias Sso.Profile

  @valid_attrs %{
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
    privacy_consent: true,
    sso_privacy_consent: true,
    news_consent: true,
    data_transfer_consent: true,
    province_enployment: "Roma"
  }
  @custom_fields [
    %{
      "name" => "first_name",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => ""
    },
    %{
      "name" => "last_name",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => ""
    },
    %{
      "name" => "fiscal_code",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => ""
    },
    %{
      "name" => "date_of_birth",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => ""
    },
    %{
      "name" => "place_of_birth",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => ""
    },
    %{
      "name" => "phone_number",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => ""
    },
    %{
      "name" => "profession",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => ""
    },
    %{
      "name" => "specialization",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => ""
    },
    %{
      "name" => "board_member",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => ""
    },
    %{
      "name" => "board_number",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => ""
    },
    %{
      "name" => "province_board",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => ""
    },
    %{
      "name" => "employment",
      "data_type" => "string",
      "rule_type" => "optional",
      "default" => ""
    },
    %{
      "name" => "province_enployment",
      "data_type" => "string",
      "rule_type" => "required",
      "default" => ""
    },
    %{
      "name" => "privacy_consent",
      "data_type" => "boolean",
      "rule_type" => "required",
      "default" => "false"
    },
    %{
      "name" => "sso_privacy_consent",
      "data_type" => "boolean",
      "rule_type" => "required",
      "default" => "false"
    },
    %{
      "name" => "news_consent",
      "data_type" => "boolean",
      "rule_type" => "optional",
      "default" => "false"
    },
    %{
      "name" => "data_transfer_consent",
      "data_type" => "boolean",
      "rule_type" => "optional",
      "default" => "false"
    }
  ]

  test "registration changeset with valid attributes" do
    changeset = Profile.registration_changeset(@custom_fields, @valid_attrs)
    assert changeset.valid?
  end

  test "registration changeset with missing privacy consent" do
    changeset = Profile.registration_changeset(@custom_fields, Map.delete(@valid_attrs, :privacy_consent))
    refute changeset.valid?
    assert changeset.errors[:privacy_consent] == {"must be accepted", [validation: :acceptance]}
  end

  test "registration changeset with invalid privacy consent" do
    changeset = Profile.registration_changeset(@custom_fields, Map.put(@valid_attrs, :privacy_consent, false))
    refute changeset.valid?
    assert changeset.errors[:privacy_consent] == {"must be accepted", [validation: :acceptance]}
  end

  test "registration changeset with missing sso privacy consent" do
    changeset = Profile.registration_changeset(@custom_fields, Map.delete(@valid_attrs, :sso_privacy_consent))
    refute changeset.valid?
    assert changeset.errors[:sso_privacy_consent] == {"must be accepted", [validation: :acceptance]}
  end

  test "registration changeset with invalid sso privacy consent" do
    changeset = Profile.registration_changeset(@custom_fields, Map.put(@valid_attrs, :sso_privacy_consent, false))
    refute changeset.valid?
    assert changeset.errors[:sso_privacy_consent] == {"must be accepted", [validation: :acceptance]}
  end

  test "registration changeset with missing news consent" do
    changeset = Profile.registration_changeset(@custom_fields, Map.delete(@valid_attrs, :news_consent))

    assert changeset.valid?
    profile = Ecto.Changeset.apply_changes(changeset)
    assert profile.news_consent == false
  end

  test "registration changeset with missing data transfer consent" do
    changeset = Profile.registration_changeset(@custom_fields, Map.delete(@valid_attrs, :data_transfer_consent))

    assert changeset.valid?
    profile = Ecto.Changeset.apply_changes(changeset)
    assert profile.data_transfer_consent == false
  end

  test "update changeset with missing privacy consent" do
    changeset = Profile.update_changeset(
      @valid_attrs,
      @custom_fields,
      Map.delete(@valid_attrs, :privacy_consent)
    )

    assert changeset.valid?
  end

  test "update changeset with invalid sso privacy consent" do
    changeset = Profile.update_changeset(
      @valid_attrs,
      @custom_fields,
      Map.put(@valid_attrs, :sso_privacy_consent, false)
    )

    assert changeset.valid?
  end

  test "registration changeset with invalid required fields" do
    Enum.each([
      :first_name, :last_name, :fiscal_code, :date_of_birth, :place_of_birth,
      :phone_number, :profession, :specialization, :board_member, :board_number,
      :province_board, :province_enployment #, :employment,
    ], fn field ->
      changeset = Profile.registration_changeset(@custom_fields, Map.delete(@valid_attrs, field))
      refute changeset.valid?
      assert changeset.errors[field] == {"can't be blank", [validation: :required]}
    end)
  end

  test "update changeset with invalid required fields" do
    Enum.each([
      :first_name, :last_name, :fiscal_code, :date_of_birth, :place_of_birth,
      :phone_number, :profession, :specialization, :board_member, :board_number,
      :province_board, :province_enployment #, :employment,
    ], fn field ->
      changeset = Profile.update_changeset(
        @valid_attrs,
        @custom_fields,
        Map.delete(@valid_attrs, field)
      )

      refute changeset.valid?
      assert changeset.errors[field] == {"can't be blank", [validation: :required]}
    end)
  end

end
