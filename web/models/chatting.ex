defmodule Rumbl.Chatting do
  use Rumbl.Web, :model

  schema "chattings" do
    field :message, :string
    field :type, :string
    belongs_to :chatting_room, Rumbl.ChattingRoom
    belongs_to :discussion, Rumbl.Discussion
    belongs_to :user, Rumbl.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:message])
    |> validate_required([:message, :type])
    |> assoc_constraint(:user)
    |> assoc_constraint(:chatting_room)
    |> assoc_constraint(:discussion)
    |> foreign_key_constraint(:chatting_user_id)
  end
end
