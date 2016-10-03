defmodule Rumbl.Repo.Migrations.AddUnqieConstraintUserIdRoom do
  use Ecto.Migration

  def change do
    create unique_index(:chatting_room_users, [:user_id, :chatting_room_id], name: :user_chatting_room_unique_index)
  end
end
