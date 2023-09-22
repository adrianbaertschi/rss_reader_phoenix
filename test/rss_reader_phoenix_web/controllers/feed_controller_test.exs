defmodule RssReaderPhoenixWeb.FeedControllerTest do
  use RssReaderPhoenixWeb.ConnCase

  import RssReaderPhoenix.FeedsFixtures

  @create_attrs %{title: "some title", url: "http://mock.local/feed.xml"}
  @update_attrs %{title: "some updated title", url: "some updated url"}
  @invalid_attrs %{title: nil, url: nil}

  describe "index" do
    test "lists all feeds", %{conn: conn} do
      conn = get(conn, ~p"/feeds")
      assert html_response(conn, 200) =~ "Listing Feeds"
    end
  end

  describe "new feed" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/feeds/new")
      assert html_response(conn, 200) =~ "New Feed"
    end
  end

  describe "create feed" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/feeds", feed: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/feeds/#{id}"

      conn = get(conn, ~p"/feeds/#{id}")
      assert html_response(conn, 200) =~ "Feed #{id}"
    end

  end

  describe "edit feed" do
    setup [:create_feed]

    test "renders form for editing chosen feed", %{conn: conn, feed: feed} do
      conn = get(conn, ~p"/feeds/#{feed}/edit")
      assert html_response(conn, 200) =~ "Edit Feed"
    end
  end

  describe "update feed" do
    setup [:create_feed]

    test "redirects when data is valid", %{conn: conn, feed: feed} do
      conn = put(conn, ~p"/feeds/#{feed}", feed: @update_attrs)
      assert redirected_to(conn) == ~p"/feeds/#{feed}"

      conn = get(conn, ~p"/feeds/#{feed}")
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, feed: feed} do
      conn = put(conn, ~p"/feeds/#{feed}", feed: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Feed"
    end
  end

  describe "delete feed" do
    setup [:create_feed]

    test "deletes chosen feed", %{conn: conn, feed: feed} do
      conn = delete(conn, ~p"/feeds/#{feed}")
      assert redirected_to(conn) == ~p"/feeds"

      assert_error_sent 404, fn ->
        get(conn, ~p"/feeds/#{feed}")
      end
    end
  end

  defp create_feed(_) do
    feed = feed_fixture()
    %{feed: feed}
  end
end
