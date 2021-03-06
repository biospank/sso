defmodule Backoffice.ErrorView do
  use Backoffice.Web, :view

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("498.html", _assigns) do
    "Authentication required (invalid token)"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  def render(_status, %{errors: errors}) do
    %{
      errors: errors
    }
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
