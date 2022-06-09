defmodule GithubStarredRepo.Repo do
  use Ecto.Repo,
    otp_app: :github_starred_repo,
    adapter: Ecto.Adapters.Postgres
end
