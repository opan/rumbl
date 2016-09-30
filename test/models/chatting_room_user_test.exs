defmodule Rumbl.ChattingRoomUserTest do
  use Rumbl.ModelCase

  alias Rumbl.ChattingRoomUser

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ChattingRoomUser.changeset(%ChattingRoomUser{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ChattingRoomUser.changeset(%ChattingRoomUser{}, @invalid_attrs)
    refute changeset.valid?
  end
end
