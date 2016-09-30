defmodule Rumbl.Repo.Migrations.CreateChattingRoom do
  use Ecto.Migration

  def change do
    create table(:chatting_rooms) do
      add :name, :string

      timestamps()
    end

  end
end
