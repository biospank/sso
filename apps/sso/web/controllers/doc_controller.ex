defmodule Sso.DocController do
  use Sso.Web, :controller

  def index(conn, _params) do
    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> Plug.Conn.send_file(200, Application.app_dir(:sso, "priv/static/index.html")) # or :code.priv_dir(my_app)
  end
end
