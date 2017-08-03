defmodule Backoffice.UserController do
  use Backoffice.Web, :controller
  require Logger

  alias Sso.{User, Account}

  def index(conn, params) do
    query_filter = case params["filters"] do
      nil ->
        User
      %{"field" => field, "term" => term, "email" => email, "status" => status, "account" => account, "organization" => organization} ->
        User
        |> User.filter_profile_by(field, term)
        |> User.filter_by(:email, email)
        |> User.filter_by_status(status)
        |> User.filter_by_account(account)
        |> User.filter_by_organization(organization)
    end

    paged_users =
      query_filter
      |> User.order_by(:inserted_at)
      |> Ecto.Query.preload(:organization)
      |> Ecto.Query.preload(:account)
      |> Backoffice.Repo.paginate(params)

    render(conn, Sso.UserView, "paginated_users.json", page: paged_users)
  end

  def show(conn, %{"id" => user_id}) do
    user = User
    |> Ecto.Query.preload(:organization)
    |> Ecto.Query.preload(:account)
    |> Sso.Repo.get!(String.to_integer(user_id))

    render(conn, Sso.UserView, "show_with_org_and_account.json", user: user)
  end

  def activate(conn, %{"user_id" => user_id}) do
    user = Sso.Repo.get!(User, String.to_integer(user_id))

    updated_user =
      user
      |> Ecto.Changeset.change(active: true)
      |> Sso.Repo.update!
      |> Sso.Repo.preload(:organization)
      |> Sso.Repo.preload(:account)

    render(conn, Sso.UserView, "show_with_org_and_account.json", user: updated_user)
  end

  def deactivate(conn, %{"user_id" => user_id}) do
    user = Sso.Repo.get!(User, String.to_integer(user_id))

    updated_user =
      user
      |> Ecto.Changeset.change(active: false)
      |> Sso.Repo.update!
      |> Sso.Repo.preload(:organization)
      |> Sso.Repo.preload(:account)

    render(conn, Sso.UserView, "show_with_org_and_account.json", user: updated_user)
  end

  def authorize(conn, %{"user_id" => user_id}) do
    user = User |> Sso.Repo.get!(String.to_integer(user_id))

    updated_user =
      user
      |> Ecto.Changeset.change(status: :verified)
      |> Sso.Repo.update!
      |> Sso.Repo.preload(:organization)
      |> Sso.Repo.preload(:account)

    account =
      Account
      |> Ecto.Query.preload(:organization)
      |> Sso.Repo.get!(updated_user.account_id)

      case get_in(account.organization.settings, ["email_template", "verification", "active"]) do
        value when value in [true, nil] ->
          case Sso.Email.courtesy_template(updated_user, account) do
            {:error, message} ->
              Logger.error message
            {:ok, email} ->
              Sso.Mailer.deliver_later(email)
          end
        _ ->
          false
      end

    render(conn, Sso.UserView, "show_with_org_and_account.json", user: updated_user)
  end

  def password_change(conn, %{"user_id" => user_id, "user" => user_params}) do
    user = User |> Sso.Repo.get!(user_id)

    params_changeset = User.backoffice_password_change_changeset(user, user_params)

    case params_changeset.valid? do
      true ->
        user
          |> Ecto.Changeset.change(password_hash: Comeonin.Bcrypt.hashpwsalt(user_params["new_password"]))
          |> Sso.Repo.update!

        send_resp(conn, 200, "")
      false ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Backoffice.ChangesetView, "error.json", changeset: params_changeset)
    end
  end

  def email_change(conn, %{"user_id" => user_id, "user" => user_params}) do
    user = Sso.Repo.get!(User, user_id)

    params_changeset = User.backoffice_email_change_changeset(user, user_params)

    case params_changeset.valid? do
      true ->
        email_changeset =
          user
          |> Ecto.Changeset.change(email: String.downcase(user_params["new_email"]))
          |> Ecto.Changeset.unique_constraint(:email, name: :users_email_organization_id_index)

        case Sso.Repo.update(email_changeset) do
          {:ok, _} ->
            user
            |> build_assoc(:archived_users, %{
                account_id: user.account_id,
                organization_id: user.organization_id
              })
            |> Sso.ArchivedUser.clone_changeset(user)
            |> Ecto.Changeset.put_change(:new_email, user_params["new_email"])
            |> Sso.Repo.insert!

            send_resp(conn, 200, "")
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Backoffice.ChangesetView, "error.json", changeset: changeset)
        end

      false ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Backoffice.ChangesetView, "error.json", changeset: params_changeset)
    end
  end
end
