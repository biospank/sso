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
      profile: render(Sso.ProfileView, "profile.json", profile: user.profile)
    }
  end

  def render("paginated_users.json", %{page: page}) do
    %{
      users: render_many(page.entries, Sso.UserView, "user.json"),
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    }
  end
end
