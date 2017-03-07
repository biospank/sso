defmodule Backoffice.PageView do
  use Backoffice.Web, :view

  def backoffice_static_path(conn, path) do
    case Mix.env do
      :prod ->
        page_path(conn, :index) <> static_path(conn, path)
      _ ->
        static_path(conn, path)
    end
  end
end
