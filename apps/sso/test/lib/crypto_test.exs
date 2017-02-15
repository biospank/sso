defmodule Sso.CryptoTest do
  use ExUnit.Case

  test "32 char random string" do
    assert String.length(Sso.Crypto.random_string 32) == 32
  end
end
