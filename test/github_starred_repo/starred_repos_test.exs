defmodule GithubStarredRepo.Starred_reposTest do
  use GithubStarredRepo.DataCase

  alias GithubStarredRepo.Starred_repos

  describe "starred_repos" do
    alias GithubStarredRepo.Starred_repos.Starred_repo

    import GithubStarredRepo.Starred_reposFixtures

    @invalid_attrs %{description: nil, github_url: nil, language: nil, name: nil, ref_id: nil}

    test "list_starred_repos/0 returns all starred_repos" do
      starred_repo = starred_repo_fixture()
      assert Starred_repos.list_starred_repos() == [starred_repo]
    end

    test "get_starred_repo!/1 returns the starred_repo with given id" do
      starred_repo = starred_repo_fixture()
      assert Starred_repos.get_starred_repo!(starred_repo.id) == starred_repo
    end

    test "create_starred_repo/1 with valid data creates a starred_repo" do
      valid_attrs = %{description: "some description", github_url: "some github_url", language: "some language", name: "some name", ref_id: 42}

      assert {:ok, %Starred_repo{} = starred_repo} = Starred_repos.create_starred_repo(valid_attrs)
      assert starred_repo.description == "some description"
      assert starred_repo.github_url == "some github_url"
      assert starred_repo.language == "some language"
      assert starred_repo.name == "some name"
      assert starred_repo.ref_id == 42
    end

    test "create_starred_repo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Starred_repos.create_starred_repo(@invalid_attrs)
    end

    test "update_starred_repo/2 with valid data updates the starred_repo" do
      starred_repo = starred_repo_fixture()
      update_attrs = %{description: "some updated description", github_url: "some updated github_url", language: "some updated language", name: "some updated name", ref_id: 43}

      assert {:ok, %Starred_repo{} = starred_repo} = Starred_repos.update_starred_repo(starred_repo, update_attrs)
      assert starred_repo.description == "some updated description"
      assert starred_repo.github_url == "some updated github_url"
      assert starred_repo.language == "some updated language"
      assert starred_repo.name == "some updated name"
      assert starred_repo.ref_id == 43
    end

    test "update_starred_repo/2 with invalid data returns error changeset" do
      starred_repo = starred_repo_fixture()
      assert {:error, %Ecto.Changeset{}} = Starred_repos.update_starred_repo(starred_repo, @invalid_attrs)
      assert starred_repo == Starred_repos.get_starred_repo!(starred_repo.id)
    end

    test "delete_starred_repo/1 deletes the starred_repo" do
      starred_repo = starred_repo_fixture()
      assert {:ok, %Starred_repo{}} = Starred_repos.delete_starred_repo(starred_repo)
      assert_raise Ecto.NoResultsError, fn -> Starred_repos.get_starred_repo!(starred_repo.id) end
    end

    test "change_starred_repo/1 returns a starred_repo changeset" do
      starred_repo = starred_repo_fixture()
      assert %Ecto.Changeset{} = Starred_repos.change_starred_repo(starred_repo)
    end
  end
end
