defmodule Sso.Plugs.VersionTest do
  use Sso.ConnCase

  describe "call" do
    @correct_accept_header "application/vnd.dardy.sso.v1+json"
    test "the client send '#{@correct_accept_header}' accept header" do
      conn =
        build_conn
        |> put_req_header("accept", @correct_accept_header)
        |> Sso.Plugs.Version.call(%{})

      assert Map.has_key?(conn.assigns, :version)
    end

    @json_accept_header "application/json"
    test "the client send '#{@json_accept_header}' accept header" do
      conn =
        build_conn
        |> put_req_header("accept", @json_accept_header)
        |> Sso.Plugs.Version.call(%{})

      refute Map.has_key?(conn.assigns, :version)
      assert conn.status == 406
    end

    test "the client doesn't send accept header" do
      conn =
        build_conn
        |> Sso.Plugs.Version.call(%{})

      refute Map.has_key?(conn.assigns, :version)
      assert conn.status == 406
    end
  end
end
