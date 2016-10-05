defmodule Rumbl.Discussion do
  use Rumbl.Web, :model
  @derive {Poison.Encoder, only: [:title]}

  schema "discussions" do
    field :title, :string
    has_many :chattings, Rumbl.Chatting
    has_many :discussion_votings, Rumbl.DiscussionVoting

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
