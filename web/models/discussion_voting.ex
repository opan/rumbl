defmodule Rumbl.DiscussionVoting do
  use Rumbl.Web, :model

  schema "discussion_votings" do
    field :title, :string
    field :score, :integer
    belongs_to :discussion, Rumbl.Discussion

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :score, :discussion_id])
    |> validate_required([:title, :score, :discussion_id])
    |> assoc_constraint(:discussion)
  end
end
