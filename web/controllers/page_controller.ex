defmodule Rumbl.PageController do
  use Rumbl.Web, :controller
  plug :authenticate_user when action in [:chat]

  alias Rumbl.{ChattingRoom, Chatting}

  def index(conn, _params) do
    render conn, "index.html"
  end

  def chat(conn, %{"room_id" => room_id}) do
    # Check if room exists
    room = Repo.get ChattingRoom, room_id

    if room do
      # Get current user
      user = conn.assigns.current_user

      # Find all Chatting history based on Chatting Room
      chats = Repo.all from c in Chatting, preload: [:user],
        where: c.chatting_room_id == ^room.id
      render conn, "chat.html", user: user, room: room, chats: chats
    else
      conn
      |> put_flash(:error, "Room ID was not exists")
      |> redirect(to: page_path(conn, :rooms))
    end
  end
end
