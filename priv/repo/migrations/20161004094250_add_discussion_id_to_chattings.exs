defmodule Rumbl.Repo.Migrations.AddDiscussionIdToChattings do
  use Ecto.Migration

  def change do
    alter table(:chattings) do
      add :discussion_id, :integer
    end
  end
end
