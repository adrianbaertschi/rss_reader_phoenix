defmodule MockHttpClient do
  def get("http://mock.local/feed.xml") do
    content = File.read!("test/support/fixtures/sample-rss-2.xml")
    {:ok, %HTTPoison.Response{status_code: 200, body: content}}
  end
end
