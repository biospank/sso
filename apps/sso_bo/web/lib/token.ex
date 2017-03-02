defmodule SsoBo.Token do
  @moduledoc """
  Provides hooks for Guardian plug.
  """
  use SsoBo.Web, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_status(498)
    |> render(SsoBo.ErrorView, :"498", errors: %{message: gettext("Authentication required (invalid token)")})
  end

  def unauthorized(conn, _params) do
    conn
    |> put_status(401)
    |> render(SsoBo.ErrorView, :"401", errors: %{message: gettext("Authorization required")})
  end
end
