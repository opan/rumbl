defmodule Rumbl.ChattingRoom do
  use Rumbl.Web, :model

  schema "chatting_rooms" do
    field :name, :string
    has_many :chattings, Rumbl.Chatting

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
