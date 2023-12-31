defmodule RssReaderPhoenix.Feeds do
  @moduledoc """
  The Feeds context.
  """

  @http_client Application.compile_env(:rss_reader_phoenix, Feeds, []) |> Keyword.get(:http_client, HTTPoison)

  import Ecto.Query, warn: false
  alias RssReaderPhoenix.Repo

  alias RssReaderPhoenix.Feeds.Feed
  alias RssReaderPhoenix.Feeds.Entry

  @doc """
  Returns the list of feeds.

  ## Examples

      iex> list_feeds()
      [%Feed{}, ...]

  """
  def list_feeds do
    Repo.all(Feed)
  end

  @doc """
  Gets a single feed.

  Raises `Ecto.NoResultsError` if the Feed does not exist.

  ## Examples

      iex> get_feed!(123)
      %Feed{}

      iex> get_feed!(456)
      ** (Ecto.NoResultsError)

  """
  def get_feed!(id), do: Repo.get!(Feed, id) |> Repo.preload(:entries)


  def create_feed(nil) do
    {:error, %Ecto.Changeset{}}
  end

  @doc """
  Creates a feed.

  ## Examples

      iex> create_feed(%{field: value})
      {:ok, %Feed{}}

      iex> create_feed(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_feed(url) do
    {:ok, response} = @http_client.get(url)
    {:ok, parsedFeed, _} = FeederEx.parse(response.body)

    entries =
      parsedFeed.entries
      |> Enum.map(fn e ->
        %{
          title: e.title || "no title",
          url: e.link || "no link",
          content: e.summary || "no content",
          publish_date: parseDate(e.updated)
        }
      end)

    attrs = Map.put(%{}, "entries", entries)
    attrs = Map.put(attrs, "title", parsedFeed.title)
    attrs = Map.put(attrs, "url", url)

    %Feed{}
    |> Feed.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:entries)
    |> Repo.insert()
  end

  def parseDate(input) do
    case Timex.parse(input, "{WDshort}, {D} {Mshort} {YYYY} {h24}:{m}:{s} {Zabbr}") do
      {:ok, result} ->
        result

      {:error, _} ->
        naive =
          Timex.parse!(String.slice(input, 0..-5), "{WDshort}, {D} {Mshort} {YYYY} {h24}:{m}")

        DateTime.from_naive!(naive, "Etc/UTC")
    end
  end

  @doc """
  Updates a feed.

  ## Examples

      iex> update_feed(feed, %{field: new_value})
      {:ok, %Feed{}}

      iex> update_feed(feed, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_feed(%Feed{} = feed, attrs) do
    feed
    |> Feed.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a feed.

  ## Examples

      iex> delete_feed(feed)
      {:ok, %Feed{}}

      iex> delete_feed(feed)
      {:error, %Ecto.Changeset{}}

  """
  def delete_feed(%Feed{} = feed) do
    Repo.delete(feed)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking feed changes.

  ## Examples

      iex> change_feed(feed)
      %Ecto.Changeset{data: %Feed{}}

  """
  def change_feed(%Feed{} = feed, attrs \\ %{}) do
    Feed.changeset(feed, attrs)
  end

  def add_entry_to_feed(%Feed{} = feed) do
    %Entry{title: "Demo", url: "www.test.com", content: "bla"}
    |> Entry.changeset(%{})
    |> Ecto.Changeset.put_assoc(:feed, feed)
    |> Repo.insert()
  end

  @doc """
  Returns the list of entries.

  ## Examples

      iex> list_entries()
      [%Entry{}, ...]

  """
  def list_entries do
    Repo.all(Entry)
  end

  @doc """
  Gets a single entry.

  Raises `Ecto.NoResultsError` if the Entry does not exist.

  ## Examples

      iex> get_entry!(123)
      %Entry{}

      iex> get_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_entry!(id), do: Repo.get!(Entry, id)

  @doc """
  Creates a entry.

  ## Examples

      iex> create_entry(%{field: value})
      {:ok, %Entry{}}

      iex> create_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_entry(attrs \\ %{}) do
    %Entry{}
    |> Entry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a entry.

  ## Examples

      iex> update_entry(entry, %{field: new_value})
      {:ok, %Entry{}}

      iex> update_entry(entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_entry(%Entry{} = entry, attrs) do
    entry
    |> Entry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a entry.

  ## Examples

      iex> delete_entry(entry)
      {:ok, %Entry{}}

      iex> delete_entry(entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_entry(%Entry{} = entry) do
    Repo.delete(entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking entry changes.

  ## Examples

      iex> change_entry(entry)
      %Ecto.Changeset{data: %Entry{}}

  """
  def change_entry(%Entry{} = entry, attrs \\ %{}) do
    Entry.changeset(entry, attrs)
  end
end
