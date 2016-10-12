defmodule Rumbl.DiscussionView do
  use Rumbl.Web, :view

  # If you getting errors (Poison.EncodeError) unable to encode value: {nil, "discussions"}
  # Then check this post http://stackoverflow.com/questions/32549712/encoding-a-ecto-model-to-json-in-elixir/32553676#32553676
  def render("upvote.json", %{message: message}) do
    %{message: message}
  end

  def render("downvote.json", %{message: message}) do
    %{message: message}
  end

  def render("blast.json", %{}) do
    %{message: "response blast"}
  end
end
