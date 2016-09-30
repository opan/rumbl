defmodule Rumbl.Repo.Migrations.CreateChattingRoomUser do
  use Ecto.Migration

  def change do
    create table(:chatting_room_users) do
      add :user_id, references(:users, on_delete: :nothing)
      add :chatting_room_id, references(:chatting_rooms, on_delete: :nothing)

      timestamps()
    end
    create index(:chatting_room_users, [:user_id])
    create index(:chatting_room_users, [:chatting_room_id])

  end
end
