defmodule SsoBo.UserView do
  use SsoBo.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, SsoBo.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, SsoBo.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username
    }
  end
end
