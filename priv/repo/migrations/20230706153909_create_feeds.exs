defmodule RssReaderPhoenix.Repo.Migrations.CreateFeeds do
  use Ecto.Migration

  def change do
    create table(:feeds) do
      add :url, :string
      add :title, :string

      timestamps()
    end
  end
end
