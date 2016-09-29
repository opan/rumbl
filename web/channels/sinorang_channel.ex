defmodule Rumbl.SinorangChannel do
  use Phoenix.Channel
  alias Rumbl.Presence

  def join("sinorang:main", _payload, socket) do
    send self(), :after_join
    {:ok, socket}
  end

  # def handle_in("new_message", payload, socket) do
  #   broadcast! socket, "new_message", payload
  #   {:noreply, socket}
  # end

  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.user, %{
      online_at: :os.system_time(:milli_seconds)
    })
    push socket, "presence_state", Presence.list(socket)
    {:noreply, socket}
  end

  def handle_in("message:new", message, socket) do
    broadcast! socket, "message:new", %{
      user: socket.assigns.user,
      body: message,
      timestamp: :os.system_time(:milli_seconds)
    }
    {:noreply, socket}
  end
end
