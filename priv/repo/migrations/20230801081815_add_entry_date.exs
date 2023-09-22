defmodule RssReaderPhoenix.Repo.Migrations.AddEntryDate do
  use Ecto.Migration

  def change do
    alter table(:entries) do
      add :publish_date, :utc_datetime
    end
  end
end
