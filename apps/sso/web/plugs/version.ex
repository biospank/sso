defmodule Sso.Plugs.Version do
  @moduledoc """
    Provides a plug filter for api versioning
  """
  import Plug.Conn

  @versions Application.get_env(:mime, :types)

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_req_header(conn, "accept") do
      [accept] ->
        _call(conn, Map.fetch(@versions, accept))
      _ ->
        _call(conn, nil)
    end
  end

  defp _call(conn, {:ok, [version]}) do
    assign(conn, :version, version)
  end
  defp _call(conn, _) do
    conn
    |> send_resp(406, "Not Acceptable")
    |> halt
  end
end
