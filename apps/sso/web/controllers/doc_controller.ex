defmodule Sso.DocController do
  use Sso.Web, :controller

  def index(conn, %{"locale" => locale}) when locale in ["it", "en"] do
    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> Plug.Conn.send_file(200, Application.app_dir(:sso, "priv/static/#{locale}.html")) # or :code.priv_dir(my_app)
  end

  def index(conn, _params) do
    conn
    |> redirect(to: "/sso/doc/it")
  end
end
