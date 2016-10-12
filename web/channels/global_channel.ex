defmodule Rumbl.GlobalChannel do
  use Phoenix.Channel

  def join("global:" <> global_id, _params, socket) do
    List.duplicate("-", 100) |> Enum.join |> IO.puts
    {:ok, socket}
  end
end
