defmodule Sso.Plugs.Locale do
  @moduledoc """
    Provides a plug to set Gettext locale
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_req_header(conn, "accept-language") do
      [locale] ->
        Gettext.put_locale(Sso.Gettext, locale)
        conn
      _ ->
        conn
    end
  end
end
