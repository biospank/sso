defmodule Sso.User do
  @moduledoc false
  use Sso.Web, :model

  alias Sso.Crypto

  schema "users" do
    field :email, :string
    field :new_email
    field :password, :string, virtual: true
    field :new_password, :string, virtual: true
    field :password_hash, :string
    field :activation_code, :string
    field :reset_code, :string
    field :email_change_code, :string
    field :active, :boolean, read_after_writes: true
    field :status, StatusEnum, read_after_writes: true
    embeds_one :profile, Sso.Profile

    belongs_to :account, Sso.Account
    belongs_to :organization, Sso.Organization
    has_many :archived_users, Sso.ArchivedUser

    timestamps
  end

  defimpl Bamboo.Formatter, for: Sso.User do
    # Used by `to`, `bcc`, `cc` and `from`
    def format_email_address(user, _opts) do
      {"", user.email}
    end
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
  end

  def registration_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast_embed(:profile, required: true, with: &Sso.Profile.registration_changeset/2)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email, name: :users_email_organization_id_index)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, required: true, message: "does not match password")
    |> put_password_hash()
    |> put_activation_code()
  end

  def activate_and_authorize_changeset(struct) do
    struct
    |> activate_changeset
    |> Ecto.Changeset.change(status: :verified)
  end

  def gen_crypto_code_changeset_for(struct, field) do
    Ecto.Changeset.change(struct, [{field, Crypto.random_string(32)}])
  end

  def password_reset_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, required: true, message: "does not match password")
    |> put_password_hash()
  end

  def activate_changeset(struct) do
    Ecto.Changeset.change(struct, active: true)
  end

  def password_change_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:password, :new_password])
    |> validate_required([:password, :new_password])
    |> validate_length(:new_password, min: 6)
    |> validate_confirmation(:new_password, required: true, message: "non corrisponde")
    |> put_new_password_hash()
  end

  def backoffice_password_change_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:new_password])
    |> validate_required([:new_password])
    |> validate_length(:new_password, min: 6)
    |> validate_confirmation(:new_password, required: true, message: "does not match")
    # |> put_new_password_hash()
  end

  def email_change_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:new_email, :password])
    |> validate_required([:new_email, :password])
    |> validate_format(:new_email, ~r/@/)
    |> validate_confirmation(:new_email, required: true, message: "does not match")
  end

  def backoffice_email_change_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:new_email])
    |> validate_required([:new_email])
    |> validate_format(:new_email, ~r/@/)
    |> validate_confirmation(:new_email, required: true, message: "does not match")
  end

  # used for password reset
  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  # used for password change
  defp put_new_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{new_password: new_pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(new_pass))
      _ ->
        changeset
    end
  end

  defp put_activation_code(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :activation_code, Crypto.random_string(32))
      _ ->
        changeset
    end
  end

  def gen_registration_link(user, %{"callback_url" => callback_url}) do
    callback_url <> "?code=#{user.activation_code}"
  end
  def gen_registration_link(_, _) do
    nil
  end

  def gen_password_reset_link(user, %{"callback_url" => callback_url}) do
    callback_url <> "?code=#{user.reset_code}"
  end
  def gen_password_reset_link(_, _) do
    nil
  end

  def gen_email_change_link(user, %{"callback_url" => callback_url}) do
    callback_url <> "?code=#{user.email_change_code}"
  end
  def gen_email_change_link(_, _) do
    nil
  end

  def filter_by(query, field, term) do
    case String.strip(term) do
      "" ->
        query
      stripped_term ->
        from u in query,
          where: ilike(field(u, ^field), ^"%#{stripped_term}%")
    end
  end

  def filter_by_status(query, status) do
    case String.strip(status) do
      "" ->
        query
      stripped_term ->
        from u in query,
          where: u.status == ^(String.to_atom(stripped_term))
    end
  end

  def filter_by_account(query, account) do
    case String.strip(account) do
      "" ->
        query
      stripped_term ->
        from u in query,
          where: u.account_id == ^(String.to_integer(stripped_term))
    end
  end

  def filter_by_organization(query, organization) when is_binary(organization) do
    case String.strip(organization) do
      "" ->
        query
      stripped_term ->
        from u in query,
          where: u.organization_id == ^(String.to_integer(stripped_term))
    end
  end
  def filter_by_organization(query, organization) do
    from u in query,
      where: u.organization_id == ^organization
  end

  def filter_profile_by(query, field, term) when is_binary(term) do
    case String.strip(term) do
      "" ->
        query
      stripped_term ->
        from u in query,
          where: fragment("?->>? LIKE ?", u.profile, ^field, ^"%#{stripped_term}%")
    end
  end
  def filter_profile_by(query, _, term) when is_nil(term), do: query

  def order_by(query, order) do
    case order do
      ts when ts in [:inserted_at, :updated_at] ->
        from v in query, order_by: [desc: field(v, ^order)]
      _ ->
        from v in query, order_by: field(v, ^order)
    end
  end

  def limit(query, size) do
    from v in query, limit: ^size
  end

  def preview() do
    %Sso.User{
      email: "mario.rossi@example.com",
      new_email: "vasco.rossi@example.com",
      profile: %Sso.Profile{
        first_name: "Mario",
        last_name: "Rossi",
        fiscal_code: "mrarss21s50h501z",
        date_of_birth: "1981-02-12",
        place_of_birth: "Roma",
        phone_number: "062277266",
        profession: "Pediatra",
        specialization: "Pediatria",
        board_member: "Medici",
        board_number: "3773662882",
        province_board: "Roma",
        employment: "Medico generico",
        sso_privacy_consent: true,
        privacy_consent: false,
        news_consent: false,
        data_transfer_consent: false,
        province_enployment: "Roma"
      },
      activation_code: "G89PAzhqjShK5_hBEZkbn_QrI5bpEK1E",
      reset_code: "Bqw75sWHV_Ufmnu7n3aLawBfU7gbp4XC",
      email_change_code: "Ast75sBST_Ufmnu7n3aLteBfU7yui4YZ",
      active: false,
      status: :unverified
    }
  end

  def to_lowercase(field, term) do
    from u in __MODULE__,
      where: fragment("lower(?)", field(u, ^field)) == ^String.downcase(term || "")
  end
end
