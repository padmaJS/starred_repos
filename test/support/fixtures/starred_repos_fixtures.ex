defmodule GithubStarredRepo.Starred_reposFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GithubStarredRepo.Starred_repos` context.
  """

  @doc """
  Generate a starred_repo.
  """
  def starred_repo_fixture(attrs \\ %{}) do
    {:ok, starred_repo} =
      attrs
      |> Enum.into(%{
        description: "some description",
        github_url: "some github_url",
        language: "some language",
        name: "some name",
        ref_id: 42
      })
      |> GithubStarredRepo.Starred_repos.create_starred_repo()

    starred_repo
  end
end
