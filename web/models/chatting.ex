defmodule Rumbl.Chatting do
  use Rumbl.Web, :model

  schema "chattings" do
    field :message, :string
    belongs_to :chatting_room, Rumbl.ChattingRoom
    belongs_to :user, Rumbl.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:message])
    |> validate_required([:message])
    |> assoc_constraint(:user)
  end
end
