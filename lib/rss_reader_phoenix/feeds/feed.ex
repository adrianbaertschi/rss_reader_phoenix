defmodule RssReaderPhoenix.Feeds.Feed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feeds" do
    field :title, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(feed, attrs) do
    feed
    |> cast(attrs, [:url, :title])
    |> validate_required([:url, :title])
  end
end
