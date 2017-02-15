defmodule Sso.Crypto do
  @moduledoc """
  Utility module for crypting stuff.
  """

  @doc """
  Generates random crypted string based on length parameter

  ## Examples

      iex> Sso.Crypto.random_string 20
      skkIInbIIhikIOJ
  """
  def random_string(length) do
    length |> :crypto.strong_rand_bytes |> Base.url_encode64 |> binary_part(0, length)
  end
end
