defmodule Rumbl.Repo.Migrations.CreateDiscussion do
  use Ecto.Migration

  def change do
    create table(:discussions) do
      add :title, :string, null: false

      timestamps()
    end

  end
end
