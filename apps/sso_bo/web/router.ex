defmodule SsoBo.Router do
  use SsoBo.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Dardy"
    plug Guardian.Plug.EnsureAuthenticated, handler: SsoBo.Token
    plug Guardian.Plug.LoadResource
  end

  scope "/sso/admin", SsoBo do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/sso/admin/api", SsoBo do
    pipe_through [:api]

    resources "/signin", SessionController, only: [:create]
  end

  scope "/sso/admin/api", SsoBo do
    pipe_through [:api, :api_auth]

  end
  # Other scopes may use custom stacks.
  # scope "/api", SsoBo do
  #   pipe_through :api
  # end
end
