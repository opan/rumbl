defmodule Rumbl.Repo.Migrations.AddTypeToChattings do
  use Ecto.Migration

  def change do
    alter table(:chattings) do
      add :type, :string, null: false, default: "plain"
    end
  end
end
