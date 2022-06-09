defmodule GithubStarredRepoWeb.Starred_repoController do
  use GithubStarredRepoWeb, :controller

  alias GithubStarredRepo.Accounts
  alias GithubStarredRepo.Starred_repos
  alias GithubStarredRepo.Starred_repos.Starred_repo

  def index(conn, params) do
    user = Accounts.get_user_by_name(params["name"])
    starred_repos = Starred_repos.get_starred_repos(user)
    render(conn, "index.html", starred_repos: starred_repos)
  end

  def new(conn, _params) do
    changeset = Starred_repos.change_starred_repo(%Starred_repo{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"starred_repo" => starred_repo_params}) do
    case Starred_repos.create_starred_repo(starred_repo_params) do
      {:ok, starred_repo} ->
        conn
        |> put_flash(:info, "Starred repo created successfully.")
        |> redirect(to: Routes.starred_repo_path(conn, :show, starred_repo))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    starred_repo = Starred_repos.get_starred_repo!(id)
    render(conn, "show.html", starred_repo: starred_repo)
  end

  def edit(conn, %{"id" => id}) do
    starred_repo = Starred_repos.get_starred_repo!(id)
    changeset = Starred_repos.change_starred_repo(starred_repo)
    render(conn, "edit.html", starred_repo: starred_repo, changeset: changeset)
  end

  def update(conn, %{"id" => id, "starred_repo" => starred_repo_params}) do
    starred_repo = Starred_repos.get_starred_repo!(id)

    case Starred_repos.update_starred_repo(starred_repo, starred_repo_params) do
      {:ok, starred_repo} ->
        conn
        |> put_flash(:info, "Starred repo updated successfully.")
        |> redirect(to: Routes.starred_repo_path(conn, :show, starred_repo))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", starred_repo: starred_repo, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    starred_repo = Starred_repos.get_starred_repo!(id)
    {:ok, _starred_repo} = Starred_repos.delete_starred_repo(starred_repo)

    conn
    |> put_flash(:info, "Starred repo deleted successfully.")
    |> redirect(to: Routes.starred_repo_path(conn, :index))
  end
end
