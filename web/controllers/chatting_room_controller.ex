defmodule Rumbl.ChattingRoomController do
  use Rumbl.Web, :controller
  plug :authenticate_user when action in [:index, :new, :create]

  alias Rumbl.{ChattingRoom}

  def index(conn, _params) do
    chatting_rooms = Repo.all ChattingRoom
    render conn, "index.html", rooms: chatting_rooms
  end

  def new(conn, _params) do
    changeset = ChattingRoom.changeset(%ChattingRoom{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"chatting_room" => chatting_room}) do
    changeset = ChattingRoom.changeset(%ChattingRoom{}, chatting_room)

    case Repo.insert(changeset) do
      {:ok, chatting_room} ->
        conn
        |> put_flash(:info, "#{chatting_room.name} successfully created")
        |> redirect(to: chatting_room_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    chatting_room = Repo.get!(ChattingRoom, id)
    changeset = ChattingRoom.changeset(chatting_room)
    render conn, "edit.html", changeset: changeset, chatting_room: chatting_room
  end

  def update(conn, %{"id" => id, "chatting_room" => chatting_room_params}) do
    chatting_room = Repo.get!(ChattingRoom, id)
    changeset = ChattingRoom.changeset(chatting_room, chatting_room_params)

    case Repo.update(changeset) do
      {:ok, chatting_room} ->
        conn
        |> put_flash(:info, "#{chatting_room.name} successfully updated")
        |> redirect(to: chatting_room_path(conn, :index), changeset: changeset, chatting_room: chatting_room)
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    chatting_room = Repo.get!(ChattingRoom, id)

    Repo.delete!(chatting_room)

    conn
    |> put_flash(:info, "#{chatting_room.name} successfully deleted")
    |> redirect(to: chatting_room_path(conn, :index))
  end
end
