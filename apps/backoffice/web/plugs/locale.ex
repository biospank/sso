defmodule Backoffice.Plugs.Locale do
  @moduledoc """
    Provides a plug to set Gettext locale
  """
  def init(opts), do: opts

  def call(conn, _opts) do
    Gettext.put_locale(Backoffice.Gettext, "it")
    conn
  end
end
