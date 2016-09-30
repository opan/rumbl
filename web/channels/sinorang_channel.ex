defmodule Rumbl.SinorangChannel do
  use Phoenix.Channel
  alias Rumbl.{Presence, Chatting, Repo}

  def join("sinorang:main", _payload, socket) do
    send self(), :after_join
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.user.name, %{
      online_at: :os.system_time(:milli_seconds)
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

    Chatting.changeset(%Chatting{
      user_id: socket.assigns.user.id,
      message: message
    })
      |> Repo.insert!()


    {:noreply, socket}
  end
end
