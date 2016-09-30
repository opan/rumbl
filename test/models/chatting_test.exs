defmodule Rumbl.ChattingTest do
  use Rumbl.ModelCase

  alias Rumbl.Chatting

  @valid_attrs %{message: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Chatting.changeset(%Chatting{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Chatting.changeset(%Chatting{}, @invalid_attrs)
    refute changeset.valid?
  end
end
