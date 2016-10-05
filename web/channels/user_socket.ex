defmodule Rumbl.UserSocket do
  use Phoenix.Socket

  alias Rumbl.{User, Repo, ChattingRoom, Discussion}

  ## Channels
  # channel "room:*", Rumbl.RoomChannel
  channel "sinorang:*", Rumbl.SinorangChannel
  channel "discussion:*", Rumbl.DiscussionChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  # def connect(%{"token" => token, "subtopic_id" => subtopic_id, "chat_type" => chat_type}, socket) do
  def connect(%{"token" => token, "subtopic_id" => subtopic_id, "chat_type" => chat_type}, socket) do
    cond do
      chat_type == "plain_chat" ->
        plain_chat(socket, token, subtopic_id)
      chat_type == "discussion_vote_chat" ->
        discussion_vote_chat(socket, token, subtopic_id)
      true ->
        :error
    end

  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Rumbl.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(socket) do
    "#{socket.assigns.chat_type}:#{socket.assigns.user.id}"
  end

  defp plain_chat(socket, token, subtopic_id) do
    # Verify token to get back User ID
    # Set max_age: to two weeks
    case Phoenix.Token.verify(socket, "user", token, max_age: 1209600) do
      {:ok, user_id} ->
        room = Repo.get(ChattingRoom, subtopic_id)

        if room do
          user = Repo.get(User, user_id)

          if user do
            {
              :ok, socket
                |> assign(:user, user)
                |> assign(:room, room)
                |> assign(:chat_type, "plain")
            }
          else
            :error
          end
        else
          :error
        end

      {:error, _} ->
        {:error, %{reason: "Token verification failed"}}
    end
  end

  defp discussion_vote_chat(socket, token, subtopic_id) do
    case Phoenix.Token.verify(socket, "user", token, max_age: 1209600) do
      {:ok, user_id} ->
        {
          :ok, socket
            |> assign(:user, Repo.get(User, user_id))
            |> assign(:discussion, Repo.get(Discussion, subtopic_id))
            |> assign(:chat_type, "discussion_vote")
        }
      {:error, _} ->
        {:error, %{reason: "Token verification failed"}}
    end
  end
end
