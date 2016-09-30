defmodule Rumbl.Repo.Migrations.CreateChatting do
  use Ecto.Migration

  def change do
    create table(:chattings) do
      add :message, :text
      add :chatting_room_id, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:chattings, [:user_id])

  end
end
