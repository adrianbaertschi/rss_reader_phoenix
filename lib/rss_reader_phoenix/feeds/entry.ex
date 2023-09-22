defmodule RssReaderPhoenix.Feeds.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field :title, :string
    field :url, :string
    field :content, :string
    field :publish_date, :utc_datetime

    belongs_to :feed, RssReaderPhoenix.Feeds.Feed

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:title, :url, :content, :publish_date])
    |> validate_required([:title, :url, :content])
  end
end
