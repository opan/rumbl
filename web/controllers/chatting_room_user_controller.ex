defmodule Rumbl.ChattingRoomUserController do
  use Rumbl.Web, :controller

  alias Rumbl.{ChattingRoomUser, ChattingRoom, User}

  def index(conn, %{"chatting_room_id" => room_id}) do
    room = Repo.get ChattingRoom, room_id
    if room do
      room_users = Repo.all from c in ChattingRoomUser,
        preload: [:user],
        where: c.chatting_room_id == ^room.id

      render conn, "index.html", room_users: room_users, room: room
    else
      conn
      |> put_flash(:error, "This room is doesn't exists")
      |> redirect(to: chatting_room_path(conn, :index))
    end
  end

  def new(conn, %{"chatting_room_id" => chatting_room_id}) do
    room = Repo.get! ChattingRoom, chatting_room_id
    users = User
      |> User.names_and_ids()
      |> Repo.all

    changeset = ChattingRoomUser.changeset(
      %ChattingRoomUser{chatting_room_id: room.id}
    )

    render conn, "new.html", changeset: changeset, room: room, users: users
  end

  def create(conn, %{"chatting_room_user" => cru_params, "chatting_room_id"=> cr_id}) do
    room = Repo.get! ChattingRoom, cr_id

    changeset = ChattingRoomUser.changeset(%ChattingRoomUser{}, cru_params)

    case Repo.insert(changeset) do
      {:ok, cru} ->
        conn
        |> put_flash(:info, "User successfully added")
        |> redirect(to: chatting_room_chatting_room_user_path(conn, :index, room))
      {:error, changeset} ->
        users = User |> User.names_and_ids() |> Repo.all
        render conn, "new.html", changeset: changeset, room: room, users: users
    end
  end

  def delete(conn, %{"id" => id, "chatting_room_id" => cr_id}) do
    room = Repo.get ChattingRoom, cr_id
    changeset = Repo.get! ChattingRoomUser, id

    Repo.delete! changeset

    conn
    |> put_flash(:info, "Success delete")
    |> redirect(to:  chatting_room_chatting_room_user_path(conn, :index, room))
  end
end
