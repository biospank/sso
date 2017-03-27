defmodule Sso.User do
  @moduledoc false
  use Sso.Web, :model

  alias Sso.Crypto

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :new_password, :string, virtual: true
    field :password_hash, :string
    field :activation_code, :string
    field :reset_code, :string
    field :active, :boolean, read_after_writes: true
    field :status, StatusEnum, read_after_writes: true
    embeds_one :profile, Sso.Profile

    belongs_to :account, Sso.Account
    belongs_to :organization, Sso.Organization

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
    |> cast_embed(:profile, required: true)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email, name: :users_email_organization_id_index)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, required: true, message: "does not match password")
    |> put_password_hash()
    |> put_activation_code()
  end

  def authorize_changeset(struct) do
    struct
    |> Ecto.Changeset.change(active: true, status: :verified)
  end

  def gen_code_reset_changeset(struct) do
    Ecto.Changeset.change(struct, reset_code: Crypto.random_string(32))
  end

  def password_reset_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, required: true, message: "does not match password")
    |> put_password_hash()
  end

  def activation_changeset(struct) do
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
end
