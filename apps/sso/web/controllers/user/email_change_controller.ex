defmodule Sso.User.EmailChangeController do
  use Sso.Web, :controller

  require Logger

  alias Sso.{User, ArchivedUser, Email, Mailer, Repo}

  plug :scrub_params, "user" when action in [:create]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [
        conn,
        conn.params,
        Guardian.Plug.current_resource(conn)
      ]
    )
  end

  def create(conn, %{"user" => user_params}, account) do
    user_changeset = User.email_change_changeset(%User{}, user_params)

    check_unique_new_mail_query =
      User.to_lowercase(:email, user_params["new_email"])
      |> User.filter_by_organization(account.organization_id)

    changeset =
      case Repo.one(check_unique_new_mail_query) do
        nil ->
          user_changeset
        _ ->
          Ecto.Changeset.add_error(user_changeset, :new_email, gettext("has already been taken"))
      end

    case changeset.valid? do
      true ->
        user_query =
          User.to_lowercase(:email, user_params["email"])
          |> User.filter_by_organization(account.organization_id)

        case Repo.one(user_query) do
          nil ->
            changeset =
              Ecto.Changeset.change(%User{})
              |> Ecto.Changeset.add_error(:email, gettext("not found"))

            conn
            |> put_status(:not_found)
            |> render(Sso.ChangesetView, "error.json", changeset: changeset)
          user ->
            if Comeonin.Bcrypt.checkpw(user_params["password"], user.password_hash) do
              {:ok, user} =
                user
                |> User.gen_crypto_code_changeset_for(:email_change_code)
                |> Ecto.Changeset.put_change(:new_email, user_params["new_email"])
                |> Repo.update

              location = User.gen_email_change_link(user, user_params)

              account =
                account
                |> Repo.preload(:organization)

              case Email.email_address_change_template(user_params["new_email"], user, account, location) do
                {:error, message} ->
                  Logger.error message
                {:ok, email} ->
                  Mailer.deliver_later(email)
              end

              send_resp conn, 201, ""
            else
              changeset =
                Ecto.Changeset.change(%User{})
                |> Ecto.Changeset.add_error(:password, gettext("not valid"))

              conn
              |> put_status(:unauthorized)
              |> render(Sso.ChangesetView, "error.json", changeset: changeset)
            end
        end

      false ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Sso.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => email_change_code}, account) do
    user = Repo.get_by(User, email_change_code: email_change_code)

    cond do
      user ->
        user
        |> build_assoc(:archived_users, %{
            account_id: account.id,
            organization_id: account.organization_id
          })
        |> ArchivedUser.clone_changeset(user)
        |> Repo.insert!

        user =
          user
          |> Ecto.Changeset.change(
              email: user.new_email,
              email_change_code: nil,
              new_email: nil
            )
          |> Repo.update!

        render(conn, Sso.UserView, "show.json", user: user)
      true ->
        error_changeset =
          Ecto.Changeset.change(%User{})
          |> Ecto.Changeset.add_error(:code, gettext("not found"))

        conn
        |> put_status(:not_found)
        |> render(Sso.ChangesetView, "error.json", changeset: error_changeset)
    end
  end
end
