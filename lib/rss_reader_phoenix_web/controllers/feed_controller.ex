defmodule RssReaderPhoenixWeb.FeedController do
  use RssReaderPhoenixWeb, :controller

  alias RssReaderPhoenix.Feeds
  alias RssReaderPhoenix.Feeds.Feed

  def index(conn, _params) do
    feeds = Feeds.list_feeds()
    render(conn, :index, feeds: feeds)
  end

  def new(conn, _params) do
    changeset = Feeds.change_feed(%Feed{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"feed" => feed_params}) do
    case Feeds.create_feed(feed_params["url"]) do
      {:ok, feed} ->
        conn
        |> put_flash(:info, "Feed created successfully.")
        |> redirect(to: ~p"/feeds/#{feed}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    feed = Feeds.get_feed!(id)
    render(conn, :show, feed: feed)
  end

  def edit(conn, %{"id" => id}) do
    feed = Feeds.get_feed!(id)
    changeset = Feeds.change_feed(feed)
    render(conn, :edit, feed: feed, changeset: changeset)
  end

  def update(conn, %{"id" => id, "feed" => feed_params}) do
    feed = Feeds.get_feed!(id)

    case Feeds.update_feed(feed, feed_params) do
      {:ok, feed} ->
        conn
        |> put_flash(:info, "Feed updated successfully.")
        |> redirect(to: ~p"/feeds/#{feed}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, feed: feed, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    feed = Feeds.get_feed!(id)
    {:ok, _feed} = Feeds.delete_feed(feed)

    conn
    |> put_flash(:info, "Feed deleted successfully.")
    |> redirect(to: ~p"/feeds")
  end

  def refresh(conn, %{"id" => id}) do
    feed = Feeds.get_feed!(id)
    Feeds.add_entry_to_feed(feed)

    conn
    |> put_flash(:info, "Refresh done")
    |> redirect(to: ~p"/feeds")
  end


end
