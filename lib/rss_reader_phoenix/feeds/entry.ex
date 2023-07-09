defmodule RssReaderPhoenix.Feeds.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field :title, :string
    field :url, :string
    field :content, :string
#    field :feed_id, :id

    belongs_to :feed, RssReaderPhoenix.Feeds.Feed

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:title, :url, :content])
    |> validate_required([:title, :url, :content])
  end
end
