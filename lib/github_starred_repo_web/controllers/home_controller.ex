defmodule GithubStarredRepoWeb.HomeController do
  use GithubStarredRepoWeb, :controller

  alias GithubStarredRepo.Starred_repos
  alias GithubStarredRepo.Accounts
  alias GithubStarredRepo.Accounts.User

  def index(conn, _) do
    conn
    |> render("index.html", changeset: User.changeset(%User{}))
  end

  def create(conn, %{"user" => params}) do
    user = Accounts.create_user(params)
    HTTPoison.get!("https://api.github.com/users/" <> params["name"] <> "/starred")
    |> Starred_repos.map_json(user)
    |> Starred_repos.create_starred_repos()

    redirect(conn, to: Routes.starred_repo_path(conn, :index, name: user.name))
  end
end
