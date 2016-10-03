defmodule Rumbl.ChattingRoomUser do
  use Rumbl.Web, :model

  schema "chatting_room_users" do
    belongs_to :user, Rumbl.User
    belongs_to :chatting_room, Rumbl.ChattingRoom

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :chatting_room_id])
    |> validate_required([:user_id, :chatting_room_id])
    # |> unique_constraint(:user_id, name: :chatting_room_users_user_id_index)
    |> unique_constraint(:user_id, name: :user_chatting_room_unique_index)
    |> assoc_constraint(:user)
    |> assoc_constraint(:chatting_room)
  end
end
