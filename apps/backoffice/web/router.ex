defmodule Backoffice.Router do
  use Backoffice.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Backoffice.Plugs.Locale
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Dardy"
    plug Guardian.Plug.EnsureAuthenticated, handler: Backoffice.Token
    plug Guardian.Plug.LoadResource
  end

  scope "/backoffice", Backoffice do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/user_export/:token", CsvController, :user_export, as: :csv_user_export
  end

  scope "/backoffice/api", Backoffice do
    pipe_through [:api]

    resources "/signin", SessionController, only: [:create]
  end

  scope "/backoffice/api", Backoffice do
    pipe_through [:api, :api_auth]

    resources "/user", UserController, only: [:index, :show] do
      put "/activate", UserController, :activate, as: :activate
      put "/deactivate", UserController, :deactivate, as: :deactivate
      put "/authorize", UserController, :authorize, as: :authorize
      put "/password/change", UserController, :password_change, as: :password_change
      put "/email/change", UserController, :email_change, as: :email_change
    end

    resources "/organization", OrganizationController, only: [:index, :create, :update]
    resources "/account", AccountController, only: [:index, :create]

    scope "/bouser", BoUser, as: :bouser do
      put "/password", PasswordController, :change
    end

    resources "/email_preview", EmailPreviewController, only: [:create]
  end
end
