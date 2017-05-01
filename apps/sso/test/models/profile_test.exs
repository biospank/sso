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
    province_enployment: "Roma"
  }

  test "registration changeset with valid attributes" do
    changeset = Profile.registration_changeset(%Profile{}, @valid_attrs)
    assert changeset.valid?
  end

  test "registration changeset with invalid privacy consent" do
    changeset = Profile.registration_changeset(%Profile{}, Map.delete(@valid_attrs, :privacy_consent))
    refute changeset.valid?
    assert changeset.errors[:privacy_consent] == {"can't be blank", [validation: :required]}
  end

  test "update changeset with invalid privacy consent" do
    changeset = Profile.update_changeset(%Profile{}, Map.delete(@valid_attrs, :privacy_consent))
    assert changeset.valid?
  end

  test "registration changeset with invalid required fields" do
    Enum.each([
      :first_name, :last_name, :fiscal_code, :date_of_birth, :place_of_birth,
      :phone_number, :profession, :specialization, :board_member, :board_number,
      :province_board, :sso_privacy_consent, :province_enployment #, :employment,
    ], fn field ->
      changeset = Profile.registration_changeset(%Profile{}, Map.delete(@valid_attrs, field))
      refute changeset.valid?
      assert changeset.errors[field] == {"can't be blank", [validation: :required]}
    end)
  end

  test "update changeset with invalid required fields" do
    Enum.each([
      :first_name, :last_name, :fiscal_code, :date_of_birth, :place_of_birth,
      :phone_number, :profession, :specialization, :board_member, :board_number,
      :province_board, :sso_privacy_consent, :province_enployment #, :employment,
    ], fn field ->
      changeset = Profile.update_changeset(%Profile{}, Map.delete(@valid_attrs, field))
      refute changeset.valid?
      assert changeset.errors[field] == {"can't be blank", [validation: :required]}
    end)
  end

end
