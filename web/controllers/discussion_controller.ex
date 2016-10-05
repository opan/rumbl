defmodule Rumbl.DiscussionController do
  use Rumbl.Web, :controller
  plug :authenticate_user when action in [:index, :votings]

  alias Rumbl.{User, Discussion, DiscussionVoting, Chatting}

  def index(conn, _params) do
    discussions = Repo.all Discussion
    render conn, "index.html", discussions: discussions
  end

  def votings(conn, %{"id" => id}) do
    discussion = Repo.get Discussion, id
    dis_votings = Repo.all from v in DiscussionVoting,
      where: v.discussion_id == ^id,
      order_by: [desc: v.score]

    chats = Repo.all from c in Chatting,
      preload: [:user],
      where: c.discussion_id == ^discussion.id and c.type == "discussion_vote"

    render conn, "votings.html", dis_votings: dis_votings, discussion: discussion, chats: chats
  end

  def upvote(conn, %{"polling_id" => polling_id, "id" => id}) do
    polling = Repo.get DiscussionVoting, polling_id
    DiscussionVoting.changeset(polling, %{score: (polling.score + 1)})
      |> Repo.update!()

    update_polling_table(id)

    render conn, "upvote.json", message: "OK"
  end

  def downvote(conn, %{"polling_id" => polling_id, "id" => id}) do
    polling = Repo.get DiscussionVoting, polling_id
    DiscussionVoting.changeset(polling, %{score: (polling.score - 1)})
      |> Repo.update!()

    render conn, "downvote.json", message: "OK"
  end

  defp update_polling_table(discussion_id) do
    discussion = Repo.get(Discussion, discussion_id)
    Rumbl.Endpoint.broadcast("discussion:#{discussion_id}", "polling:vote", %{
      discussion: discussion
    })
  end
end
