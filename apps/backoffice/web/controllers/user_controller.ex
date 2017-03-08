defmodule Backoffice.UserController do
  use Backoffice.Web, :controller

  alias Sso.User

  # def action(conn, _) do
  #   apply(__MODULE__, action_name(conn),
  #     [
  #       conn,
  #       conn.params,
  #       Guardian.Plug.current_resource(conn)
  #     ]
  #   )
  # end

  def index(conn, params) do
    paged_users =
      User
      |> User.filter_by(params["filter"])
      |> User.order_by(:inserted_at)
      |> Backoffice.Repo.paginate(params)

    # paged_users = paginate(videos, params["page"])
    #
    # paged_users = case paged_users do
    #   %Scrivener.Page{entries: [], total_entries: total} when total > 0 ->
    #     paginate(users, String.to_integer(params["page"]) - 1)
    #   _ ->
    #     paged_users
    # end

    render(conn, Sso.UserView, "paginated_users.json", page: paged_users)
  end

  # defp paginate(items, page, page_size \\ 8) do
  #   Scrivener.paginate(
  #     items,
  #     %{
  #       page: page || 1,
  #       page_size: page_size
  #     }
  #   )
  # end
end
