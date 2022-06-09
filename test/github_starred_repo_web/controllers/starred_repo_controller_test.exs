defmodule GithubStarredRepoWeb.Starred_repoControllerTest do
  use GithubStarredRepoWeb.ConnCase

  import GithubStarredRepo.Starred_reposFixtures

  @create_attrs %{description: "some description", github_url: "some github_url", language: "some language", name: "some name", ref_id: 42}
  @update_attrs %{description: "some updated description", github_url: "some updated github_url", language: "some updated language", name: "some updated name", ref_id: 43}
  @invalid_attrs %{description: nil, github_url: nil, language: nil, name: nil, ref_id: nil}

  describe "index" do
    test "lists all starred_repos", %{conn: conn} do
      conn = get(conn, Routes.starred_repo_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Starred repos"
    end
  end

  describe "new starred_repo" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.starred_repo_path(conn, :new))
      assert html_response(conn, 200) =~ "New Starred repo"
    end
  end

  describe "create starred_repo" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.starred_repo_path(conn, :create), starred_repo: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.starred_repo_path(conn, :show, id)

      conn = get(conn, Routes.starred_repo_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Starred repo"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.starred_repo_path(conn, :create), starred_repo: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Starred repo"
    end
  end

  describe "edit starred_repo" do
    setup [:create_starred_repo]

    test "renders form for editing chosen starred_repo", %{conn: conn, starred_repo: starred_repo} do
      conn = get(conn, Routes.starred_repo_path(conn, :edit, starred_repo))
      assert html_response(conn, 200) =~ "Edit Starred repo"
    end
  end

  describe "update starred_repo" do
    setup [:create_starred_repo]

    test "redirects when data is valid", %{conn: conn, starred_repo: starred_repo} do
      conn = put(conn, Routes.starred_repo_path(conn, :update, starred_repo), starred_repo: @update_attrs)
      assert redirected_to(conn) == Routes.starred_repo_path(conn, :show, starred_repo)

      conn = get(conn, Routes.starred_repo_path(conn, :show, starred_repo))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, starred_repo: starred_repo} do
      conn = put(conn, Routes.starred_repo_path(conn, :update, starred_repo), starred_repo: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Starred repo"
    end
  end

  describe "delete starred_repo" do
    setup [:create_starred_repo]

    test "deletes chosen starred_repo", %{conn: conn, starred_repo: starred_repo} do
      conn = delete(conn, Routes.starred_repo_path(conn, :delete, starred_repo))
      assert redirected_to(conn) == Routes.starred_repo_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.starred_repo_path(conn, :show, starred_repo))
      end
    end
  end

  defp create_starred_repo(_) do
    starred_repo = starred_repo_fixture()
    %{starred_repo: starred_repo}
  end
end
