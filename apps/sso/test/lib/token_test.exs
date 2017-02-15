defmodule Sso.TokenTest do
  use Sso.ConnCase

  @tag :skip
  test "unauthenticated", %{conn: conn} do
    # conn = get conn, user_path(conn, :index)
    assert json_response(conn, 401)
  end

  @tag :skip
  test "unauthorized", %{conn: conn} do
    # conn = get conn, user_path(conn, :index)
    assert json_response(conn, 401)
  end
end
