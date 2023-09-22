defmodule RssReaderPhoenix.FeedsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RssReaderPhoenix.Feeds` context.
  """

  @doc """
  Generate a feed.
  """
  def feed_fixture(attrs \\ %{}) do
    {:ok, feed} = RssReaderPhoenix.Feeds.create_feed("http://mock.local/feed.xml")
    feed
  end

  @doc """
  Generate a entry.
  """
  def entry_fixture(attrs \\ %{}) do
    {:ok, entry} =
      attrs
      |> Enum.into(%{
        title: "some title",
        url: "some url",
        content: "some content"
      })
      |> RssReaderPhoenix.Feeds.create_entry()

    entry
  end
end
