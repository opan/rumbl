defmodule Rumbl.DiscussionVotingTest do
  use Rumbl.ModelCase

  alias Rumbl.DiscussionVoting

  @valid_attrs %{score: 42, title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = DiscussionVoting.changeset(%DiscussionVoting{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = DiscussionVoting.changeset(%DiscussionVoting{}, @invalid_attrs)
    refute changeset.valid?
  end
end
