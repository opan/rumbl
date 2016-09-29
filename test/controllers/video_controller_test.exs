defmodule Rumbl.VideoControllerTest do
  use Rumbl.ConnCase

  setup do
    user = insert_user(%{username: "test"})
    conn = assign(conn(), :current_user, user)
    {:ok, conn: conn, user: user}
  end

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, video_path(conn, :new))
      ], fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end
end
