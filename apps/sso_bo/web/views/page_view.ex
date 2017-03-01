defmodule SsoBo.PageView do
  use SsoBo.Web, :view

  def sso_bo_static_path(conn, path) do
    case Mix.env do
      :prod ->
        page_path(conn, :index) <> static_path(conn, path)
      _ ->
        static_path(conn, path)
    end
  end
end
