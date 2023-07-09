defmodule RssReaderPhoenix.Repo.Migrations.EntryToFeed do
  use Ecto.Migration

  def change do
    alter table(:entries) do
      add :feed_id, references(:feeds, on_delete: :delete_all)
    end
  end
end
