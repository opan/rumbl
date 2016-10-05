defmodule Rumbl.PageController do
  use Rumbl.Web, :controller
  plug :authenticate_user when action in [:chat]
  plug :authorization_user_room when action in [:chat]

  alias Rumbl.{ChattingRoom, Chatting, ChattingRoomUser}

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
        where: c.chatting_room_id == ^room.id and c.type == "plain"
        
      render conn, "chat.html", user: user, room: room, chats: chats
    else
      conn
      |> put_flash(:error, "Room ID was not exists")
      |> redirect(to: page_path(conn, :rooms))
    end
  end

  defp authorization_user_room(conn, _opts) do
    room_id = conn.params["room_id"]

    case Repo.get_by ChattingRoomUser, chatting_room_id: room_id,
      user_id: conn.assigns.current_user.id do
        nil ->
          conn
          |> put_flash(:error, "You're not authorized to access this room")
          |> redirect(to: chatting_room_path(conn, :index))
        cru ->
          conn
    end
  end
end
