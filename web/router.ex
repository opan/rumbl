defmodule Rumbl.Router do
  use Rumbl.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
    plug Rumbl.Auth, repo: Rumbl.Repo
  end

  pipeline :csrf do
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Rumbl do
    pipe_through [:browser, :csrf] # Use the default browser stack

    get "/", PageController, :index
    get "/chat/:room_id", PageController, :chat
    resources "/users", UserController, only: [:index, :new, :create, :show, :delete]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/videos", VideoController
    resources "/chatting_rooms/", ChattingRoomController do
      resources "/users", ChattingRoomUserController, only: [:index, :delete, :new, :create]
    end

    get "/discussions", DiscussionController, :index
    get "/discussions/:id/votings", DiscussionController, :votings
  end

  scope "/", Rumbl do
    pipe_through [:browser]

    put "/discussions/:id/votings/:polling_id/upvote", DiscussionController, :upvote
    put "/discussions/:id/votings/:polling_id/downvote", DiscussionController, :downvote
    get "/discussions/blast", DiscussionController, :blast
  end

  scope "/manage", Rumbl do
    pipe_through [:browser, :authenticate_user, :csrf]

    resources "/videos", VideoController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Rumbl do
  #   pipe_through :api
  # end
end
