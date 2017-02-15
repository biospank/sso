defmodule SsoWeb.PageController do
  use SsoWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
