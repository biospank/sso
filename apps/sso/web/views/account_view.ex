defmodule Sso.AccountView do
  use Sso.Web, :view

  def render("index.json", %{accounts: accounts}) do
    %{accounts: render_many(accounts, Sso.AccountView, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{account: render_one(account, Sso.AccountView, "account.json")}
  end

  def render("show_with_credentials.json", %{account: account}) do
    %{account: render_one(account, Sso.AccountView, "account_with_credentials.json")}
  end

  def render("account.json", %{account: account}) do
    %{id: account.id,
      app_name: account.app_name,
      access_key: account.access_key,
      active: account.active}
  end

  def render("account_with_credentials.json", %{account: account}) do
    %{id: account.id,
      app_name: account.app_name,
      access_key: account.access_key,
      secret_key: account.secret_key,
      active: account.active}
  end
end
