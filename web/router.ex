defmodule Book.Router do
  use Book.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", Book do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Book do
    pipe_through :api

    resources "/contacts", ContactController, except: [:new, :edit]
    post "/users", RegistrationController, :create
    post "/login", RegistrationController, :login
    delete "/logout", RegistrationController, :logout
  end
end
