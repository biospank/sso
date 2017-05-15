defmodule Sso.Router do
  use Sso.Web, :router

  pipeline :api do
    plug :accepts, ["v1"]
    plug Sso.Plugs.Version
    plug Sso.Plugs.Locale
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Dardy"
    plug Guardian.Plug.EnsureAuthenticated, handler: Sso.Token
    plug Guardian.Plug.LoadResource
  end

  # enable to preview emails in dev mode
  # if Mix.env == :dev do
  #   forward "/sent_emails", Bamboo.EmailPreviewPlug
  # end

  scope "/sso", Sso do
    pipe_through :api

    resources "/session", SessionController, only: [:create]

    scope "/user", User, as: :user do
      pipe_through :api_auth

      get "/:id", DetailController, :show
      resources "/signup", RegistrationController, only: [:create]
      resources "/signin", SessionController, only: [:create]
      resources "/signout", SessionController, only: [:delete]
      put "/activate/:code", ActivationController, :confirm
      post "/activation/resend", ActivationController, :resend, as: :resend_activation_code
      resources "/password/reset", PasswordResetController, only: [:create, :update]
      put "/:id/profile", ProfileController, :update
      put "/:id/password/change", PasswordChangeController, :change
    end
  end

  scope "/sso", Sso do
    get "/doc", DocController, :index
  end
end
