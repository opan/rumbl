defmodule Rumbl.DiscussionTest do
  use Rumbl.ModelCase

  alias Rumbl.Discussion

  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Discussion.changeset(%Discussion{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Discussion.changeset(%Discussion{}, @invalid_attrs)
    refute changeset.valid?
  end
end
