defmodule RssReaderPhoenix.FeedsTest do
  use RssReaderPhoenix.DataCase

  alias RssReaderPhoenix.Feeds

  describe "feeds" do
    alias RssReaderPhoenix.Feeds.Feed

    import RssReaderPhoenix.FeedsFixtures

    @invalid_attrs %{title: nil, url: nil}

    test "list_feeds/0 returns all feeds" do
      expected = feed_fixture()
      actual = Feeds.list_feeds() |> hd
      assert actual.id == expected.id
      assert actual.inserted_at == expected.inserted_at
      assert actual.title == expected.title
      assert actual.updated_at == expected.updated_at
      assert actual.url == expected.url
    end

    test "get_feed!/1 returns the feed with given id" do
      feed = feed_fixture()
      assert Feeds.get_feed!(feed.id) == feed
    end

    test "create_feed/1 with valid data creates a feed" do
      assert {:ok, %Feed{} = feed} = Feeds.create_feed("http://mock.local/feed.xml")
      assert feed.title == "NASA Space Station News"
      assert feed.url == "http://mock.local/feed.xml"
    end

    test "create_feed/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Feeds.create_feed(nil)
    end

    test "update_feed/2 with valid data updates the feed" do
      feed = feed_fixture()
      update_attrs = %{title: "some updated title", url: "some updated url"}

      assert {:ok, %Feed{} = feed} = Feeds.update_feed(feed, update_attrs)
      assert feed.title == "some updated title"
      assert feed.url == "some updated url"
    end

    test "update_feed/2 with invalid data returns error changeset" do
      feed = feed_fixture()
      assert {:error, %Ecto.Changeset{}} = Feeds.update_feed(feed, @invalid_attrs)
      assert feed == Feeds.get_feed!(feed.id)
    end

    test "delete_feed/1 deletes the feed" do
      feed = feed_fixture()
      assert {:ok, %Feed{}} = Feeds.delete_feed(feed)
      assert_raise Ecto.NoResultsError, fn -> Feeds.get_feed!(feed.id) end
    end

    test "change_feed/1 returns a feed changeset" do
      feed = feed_fixture()
      assert %Ecto.Changeset{} = Feeds.change_feed(feed)
    end
  end

  describe "entries" do
    alias RssReaderPhoenix.Feeds.Entry

    import RssReaderPhoenix.FeedsFixtures

    @invalid_attrs %{title: nil, url: nil, content: nil}

    test "list_entries/0 returns all entries" do
      entry = entry_fixture()
      assert Feeds.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Feeds.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      valid_attrs = %{title: "some title", url: "some url", content: "some content"}

      assert {:ok, %Entry{} = entry} = Feeds.create_entry(valid_attrs)
      assert entry.title == "some title"
      assert entry.url == "some url"
      assert entry.content == "some content"
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Feeds.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()
      update_attrs = %{title: "some updated title", url: "some updated url", content: "some updated content"}

      assert {:ok, %Entry{} = entry} = Feeds.update_entry(entry, update_attrs)
      assert entry.title == "some updated title"
      assert entry.url == "some updated url"
      assert entry.content == "some updated content"
    end

    test "update_entry/2 with invalid data returns error changeset" do
      entry = entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Feeds.update_entry(entry, @invalid_attrs)
      assert entry == Feeds.get_entry!(entry.id)
    end

    test "delete_entry/1 deletes the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{}} = Feeds.delete_entry(entry)
      assert_raise Ecto.NoResultsError, fn -> Feeds.get_entry!(entry.id) end
    end

    test "change_entry/1 returns a entry changeset" do
      entry = entry_fixture()
      assert %Ecto.Changeset{} = Feeds.change_entry(entry)
    end

    test "date parsing" do
      # https://www.rssboard.org/files/sample-rss-2.xml
      a = "Tue, 10 Jun 2003 04:00:00 GMT"
      b = "Fri, 21 Jul 2023 09:04 EDT"

      assert parse(a) === ~U[2003-06-10 04:00:00Z]
      assert parse(b) === ~U[2023-07-21 09:04:00Z]
    end

    defp parse(input) do
      Feeds.parseDate(input)
    end
  end
end
