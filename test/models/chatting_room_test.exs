defmodule Rumbl.ChattingRoomTest do
  use Rumbl.ModelCase

  alias Rumbl.ChattingRoom

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ChattingRoom.changeset(%ChattingRoom{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ChattingRoom.changeset(%ChattingRoom{}, @invalid_attrs)
    refute changeset.valid?
  end
end
