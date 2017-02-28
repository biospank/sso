defmodule Sso.Plugs.LocaleTest do
  use Sso.ConnCase

  describe "call" do
    test "the client doesn't send accept-language header" do
      build_conn |> Sso.Plugs.Locale.call(%{})

      assert Gettext.get_locale(Sso.Gettext) == "en"
    end

    @en_accept_language_header "en"
    test "the client send '#{@en_accept_language_header}' accept-language header" do
      build_conn
      |> put_req_header("accept-language", @en_accept_language_header)
      |> Sso.Plugs.Locale.call(%{})

      assert Gettext.get_locale(Sso.Gettext) == @en_accept_language_header
    end

    @it_accept_language_header "it"
    test "the client send '#{@it_accept_language_header}' accept-language header" do
      build_conn
      |> put_req_header("accept-language", @it_accept_language_header)
      |> Sso.Plugs.Locale.call(%{})

      assert Gettext.get_locale(Sso.Gettext) == @it_accept_language_header
    end
  end
end
