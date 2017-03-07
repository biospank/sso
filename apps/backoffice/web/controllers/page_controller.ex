# require IEx

defmodule Backoffice.PageController do
  use Backoffice.Web, :controller

  def index(conn, _params) do
    # IEx.pry
    render conn, "index.html"
  end
end
