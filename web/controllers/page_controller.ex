defmodule Rumbl.PageController do
  use Rumbl.Web, :controller
  plug :authenticate_user when action in [:chat]

  def index(conn, _params) do
    render conn, "index.html"
  end

  def chat(conn, _params) do
    # Get current user
    user = conn.assigns.current_user
    render conn, "chat.html", user: user
  end
end
