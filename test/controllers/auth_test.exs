defmodule Rumbl.AuthTest do
  use Rumbl.ConnCase
  alias Rumbl.Auth

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(Rumbl.Router, :browser)
      |> get("/")
    {:ok, %{conn: conn}}
  end

  test "authenticate_user halts when no current user exists", %{conn: conn} do
    conn =
      conn
      |> assign(:current_user, nil)
      |> Auth.authenticate_user([])
    assert conn.halted
  end

  test "authenticate_user continues when the current user exists", %{conn: conn} do
    conn =
      conn
      |> assign(:current_user, %Rumbl.User{})
      |> Auth.authenticate_user([])

    refute conn.halted
  end
end
