defmodule Rumbl.Repo.Migrations.AddUniqueNameOnChattingRooms do
  use Ecto.Migration

  def change do
    create unique_index(:chatting_rooms, [:name])
  end
end
