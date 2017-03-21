defmodule Backoffice.UserController do
  use Backoffice.Web, :controller

  alias Sso.{User, Account}

  def index(conn, params) do
    query_filter = case params["filters"] do
      nil ->
        User
      %{"field" => field, "term" => term, "email" => email, "status" => status, "account" => account} ->
        User
        |> User.filter_profile_by(field, term)
        |> User.filter_by(:email, email)
        |> User.filter_by_status(status)
        |> User.filter_by_account(account)
    end

    paged_users =
      query_filter
      |> User.order_by(:inserted_at)
      |> Backoffice.Repo.paginate(params)

    render(conn, Sso.UserView, "paginated_users.json", page: paged_users)
  end

  def show(conn, %{"id" => user_id}) do
    user = Sso.Repo.get!(User, String.to_integer(user_id))
    render(conn, Sso.UserView, "show.json", user: user)
  end

  def activate(conn, %{"user_id" => user_id}) do
    user = Sso.Repo.get!(User, String.to_integer(user_id))

    updated_user =
      user
      |> Ecto.Changeset.change(active: true)
      |> Sso.Repo.update!

    render(conn, Sso.UserView, "show.json", user: updated_user)
  end

  def deactivate(conn, %{"user_id" => user_id}) do
    user = Sso.Repo.get!(User, String.to_integer(user_id))

    updated_user =
      user
      |> Ecto.Changeset.change(active: false)
      |> Sso.Repo.update!

    render(conn, Sso.UserView, "show.json", user: updated_user)
  end

  def authorize(conn, %{"user_id" => user_id}) do
    user = User |> Sso.Repo.get!(String.to_integer(user_id))

    updated_user =
      user
      |> Ecto.Changeset.change(status: :verified)
      |> Sso.Repo.update!

    account =
      Account
      |> Ecto.Query.preload(:organization)
      |> Sso.Repo.get!(updated_user.account_id)

    Sso.Email.courtesy_email(updated_user, account) |> Sso.Mailer.deliver_later

    render(conn, Sso.UserView, "show.json", user: updated_user)
  end
end
