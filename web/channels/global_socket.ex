defmodule Rumbl.GlobalSocket do
  use Phoenix.Socket

  channel "global:*", Rumbl.GlobalChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(socket), do: nil

end
