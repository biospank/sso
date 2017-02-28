# require IEx

defmodule SsoWeb.PageController do
  use SsoWeb.Web, :controller

  def index(conn, _params) do
    # IEx.pry
    render conn, "index.html"
  end
end
