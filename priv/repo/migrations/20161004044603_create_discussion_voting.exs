defmodule Rumbl.Repo.Migrations.CreateDiscussionVoting do
  use Ecto.Migration

  def change do
    create table(:discussion_votings) do
      add :title, :string, null: false
      add :score, :integer, null: false, default: 0
      add :discussion_id, references(:discussions, on_delete: :delete_all)

      timestamps()
    end
    create index(:discussion_votings, [:discussion_id])

  end
end
