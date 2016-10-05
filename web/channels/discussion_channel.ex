defmodule Rumbl.DiscussionChannel do
  use Phoenix.Channel
  alias Rumbl.{Repo, Chatting, DiscussionVoting, Presence}

  def join("discussion:" <> discussion_id, %{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user", token, max_age: 1209600) do
      {:ok, user_id} ->
        send self(), :after_join
        {:ok, socket}
      {:error, _} ->
        :error
    end
  end

  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.user.name, %{
      online_at: :os.system_time(:milli_seconds),
      discussion_name: socket.assigns.discussion.title
    })
    push socket, "presence_state", Presence.list(socket)
    {:noreply, socket}
  end

  def handle_in("message:new", message, socket) do
    broadcast! socket, "message:new", %{
      user: socket.assigns.user.name,
      body: message,
      timestamp: :os.system_time(:milli_seconds)
    }

    Ecto.build_assoc(socket.assigns.discussion, :chattings,
      user_id: socket.assigns.user.id,
      message: message,
      type: socket.assigns.chat_type
    )
      |> Repo.insert!()


    {:noreply, socket}
  end
end
