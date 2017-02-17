defmodule MasterProxy.Plug do
  def init(options) do
    options
  end

  def call(conn, _opts) do
    cond do
      conn.request_path =~ ~r{/sso/admin} ->
        SsoWeb.Endpoint.call(conn, [])
      true ->
        Sso.Endpoint.call(conn, [])
    end
  end
end
