defmodule Sso.UserView do
  use Sso.Web, :view

  def render("index.json", %{users: users}) do
    %{users: render_many(users, Sso.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{user: render_one(user, Sso.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      active: user.active,
      status: user.status,
      profile: user.profile
    }
  end
end
