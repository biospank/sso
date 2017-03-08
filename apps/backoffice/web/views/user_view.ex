defmodule Backoffice.UserView do
  use Backoffice.Web, :view

  def render("index.json", %{users: users}) do
    %{users: render_many(users, Backoffice.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{user: render_one(user, Backoffice.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username
    }
  end
end
