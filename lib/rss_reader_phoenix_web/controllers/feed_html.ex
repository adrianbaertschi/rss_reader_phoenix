defmodule RssReaderPhoenixWeb.FeedHTML do
  use RssReaderPhoenixWeb, :html

  embed_templates "feed_html/*"

  @doc """
  Renders a feed form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def feed_form(assigns)
end
