defmodule Backoffice.User do
  use Backoffice.Web, :model

  schema "bo_users" do
    field :username, :string
    field :password, :string, virtual: true
    field :new_password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :password])
    |> validate_required([:username, :password])
  end

  def password_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:password, :new_password])
    |> validate_required([:password, :new_password])
    |> validate_length(:new_password, min: 6)
    |> validate_confirmation(:new_password, required: true, message: "non corrisponde")
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{new_password: new_pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(new_pass))
      _ ->
        changeset
    end
  end
end
