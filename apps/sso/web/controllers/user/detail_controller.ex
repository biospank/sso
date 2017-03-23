defmodule Sso.User.DetailController do
  use Sso.Web, :controller

  alias Sso.User

  def show(conn, %{"id" => user_id}) do
    user = Sso.Repo.get(User, user_id)

    case user do
      nil ->
        conn
        |> put_status(404)
        |> render(Sso.ErrorView, :"404", errors: %{message: gettext("User not found")})
      _ ->
        render(conn, Sso.UserView, "show.json", user: user)
    end
  end
end
