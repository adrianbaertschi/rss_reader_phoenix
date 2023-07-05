defmodule RssReaderPhoenix.Repo do
  use Ecto.Repo,
    otp_app: :rss_reader_phoenix,
    adapter: Ecto.Adapters.Postgres
end
