defmodule GithubStarredRepoWeb.Starred_repoController do
  use GithubStarredRepoWeb, :controller

  alias GithubStarredRepo.Accounts
  alias GithubStarredRepo.Starred_repos
  alias GithubStarredRepo.Starred_repos.Starred_repo

  def index(conn, params) do
    user = Accounts.get_user_by_name(params["user"])
    starred_repos = Starred_repos.get_starred_repos(user)
    render(conn, "index.html", starred_repos: starred_repos)
  end

  def update(conn, params) do
    user = Accounts.get_user_by_name(params["user"])

    Starred_repos.owned_by(user.id, params["id"])
    |> case do
      {:ok, starred_repo} ->
        {:ok, updated_repo} =
          Starred_repos.update_starred_repo(starred_repo, %{tags: params["tags"]})

        tags =
          updated_repo.tags
          |> Enum.map_join(",", & &1.name)

        json(conn, %{success: true, message: "Tags saved successfully", tags: tags})

      {:error, msg} ->
        conn
        |> put_status(:not_found)
        |> json(%{success: false, message: msg})
    end
  end
end
