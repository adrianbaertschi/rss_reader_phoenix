defmodule RssReaderPhoenix.FeedsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RssReaderPhoenix.Feeds` context.
  """

  @doc """
  Generate a feed.
  """
  def feed_fixture(attrs \\ %{}) do
    {:ok, feed} =
      attrs
      |> Enum.into(%{
        title: "some title",
        url: "some url"
      })
      |> RssReaderPhoenix.Feeds.create_feed()

    feed
  end
end
