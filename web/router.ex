defmodule Rumbl.Router do
  use Rumbl.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Rumbl.Auth, repo: Rumbl.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Rumbl do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/chat/:room_id", PageController, :chat
    resources "/users", UserController, only: [:index, :new, :create, :show, :delete]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/videos", VideoController
    resources "/chatting_rooms/", ChattingRoomController do
      resources "/users", ChattingRoomUserController, only: [:index, :delete, :new, :create] 
    end
  end

  scope "/manage", Rumbl do
    pipe_through [:browser, :authenticate_user]

    resources "/videos", VideoController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Rumbl do
  #   pipe_through :api
  # end
end
