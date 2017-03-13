defmodule Backoffice.UserController do
  use Backoffice.Web, :controller

  alias Sso.User

  def index(conn, params) do
    IO.inspect params

    Process.sleep 1_000

    paged_users =
      User
      |> User.filter_profile_by(:first_name, params["filters"]["name"])
      |> User.order_by(:inserted_at)
      |> Backoffice.Repo.paginate(params)

    render(conn, Sso.UserView, "paginated_users.json", page: paged_users)
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
end
