defmodule SsoWeb.PageView do
  use SsoWeb.Web, :view

  def sso_web_static_path(conn, path) do
    case Mix.env do
      :prod ->
        page_path(conn, :index) <> static_path(conn, path)
      _ ->
        static_path(conn, path)
    end
  end
end
