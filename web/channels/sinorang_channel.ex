defmodule Rumbl.SinorangChannel do
  use Phoenix.Channel
  alias Rumbl.{Presence, Chatting, Repo}

  def join("sinorang:" <> room_id, %{"token" => token}, socket) do
    # IO.puts List.duplicate("*", 100) |> Enum.join
    # # IO.puts "ini di SinorangChannel"
    # # IO.inspect token
    # IO.inspect socket.id
    # IO.inspect room_id
    # IO.puts List.duplicate("*", 100) |> Enum.join

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
      room: socket.assigns.room.name
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

    Ecto.build_assoc(socket.assigns.room, :chattings,
      user_id: socket.assigns.user.id,
      message: message
    )
      |> Repo.insert!()


    {:noreply, socket}
  end
end
