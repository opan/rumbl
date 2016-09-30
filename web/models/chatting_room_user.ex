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
    |> cast(params, [])
    |> validate_required([:user_id, :chatting_room_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:chatting_room)
  end
end
