defmodule Rumbl.ChattingRoom do
  use Rumbl.Web, :model

  schema "chatting_rooms" do
    field :name, :string
    has_many :chattings, Rumbl.Chatting, on_delete: :delete_all
    many_to_many :users, Rumbl.User, join_through: "chatting_room_users", on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
