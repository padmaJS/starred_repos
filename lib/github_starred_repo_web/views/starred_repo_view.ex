defmodule GithubStarredRepoWeb.Starred_repoView do
  use GithubStarredRepoWeb, :view

  def parse_tags(tags) do
    tags
    |> Enum.map_join(", ", & &1.name)
  end
end
