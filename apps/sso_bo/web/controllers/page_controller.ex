# require IEx

defmodule SsoBo.PageController do
  use SsoBo.Web, :controller

  def index(conn, _params) do
    # IEx.pry
    render conn, "index.html"
  end
end
