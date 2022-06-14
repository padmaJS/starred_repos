defmodule GithubStarredRepo.StarredReposTags do
  use Ecto.Schema

  schema "starred_repos_tags" do
    belongs_to :starred_repo, GithubStarredRepo.Starred_repos.Starred_repo
    belongs_to :tags, GithubStarredRepo.Tags.Tag

    timestamps()
  end
end
