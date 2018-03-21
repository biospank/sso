defmodule Sso.DocControllerTest do
  use Sso.ConnCase

  describe "doc" do
    test 'with missing locale it redirects to `it` locale', %{conn: conn} do
      conn = get conn, Sso.Router.Helpers.doc_path(conn, :index, "")
      assert conn |> redirected_to == "/sso/doc/it"
    end

    test 'with unavailable locale it redirects to `it` locale', %{conn: conn} do
      conn = get conn, Sso.Router.Helpers.doc_path(conn, :index, "ru")
      assert conn |> redirected_to == "/sso/doc/it"
    end

    test 'with `it` locale it renders `it`', %{conn: conn} do
      conn = get conn, Sso.Router.Helpers.doc_path(conn, :index, "it")
      assert conn.status == 200
    end

    test 'with `en` locale it renders `en`', %{conn: conn} do
      conn = get conn, Sso.Router.Helpers.doc_path(conn, :index, "en")
      assert conn.status == 200
    end
  end
end
