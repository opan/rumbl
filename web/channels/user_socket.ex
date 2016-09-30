defmodule Rumbl.UserSocket do
  use Phoenix.Socket

  alias Rumbl.{User, Repo, ChattingRoom}

  ## Channels
  # channel "room:*", Rumbl.RoomChannel
  channel "sinorang:*", Rumbl.SinorangChannel

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
  def connect(%{"token" => token, "room_id" => room_id}, socket) do

    # Verify token to get back User ID
    # Set max_age: to two weeks
    case Phoenix.Token.verify(socket, "user", token, max_age: 1209600) do
      {:ok, user_id} ->
        room = Repo.get(ChattingRoom, room_id)

        if room do
          user = Repo.get(User, user_id)

          if user do
            {:ok, socket |> assign(:user, user) |> assign(:room, room)}
          else
            {:error, %{reason: "user not found"}}
          end
        else
          {:error, %{reason: "room not found"}}
        end

      {:error, _} ->
        {:error, %{reason: "Token verification failed"}}
    end

    # user = Repo.get(User, user_id)
    # if user do
    #   {:ok, assign(socket, :user, user)}
    # else
    #   {:error, %{reason: "User not found"}}
    # end
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
    "sinorang:#{socket.assigns.room.id}"
  end
end
