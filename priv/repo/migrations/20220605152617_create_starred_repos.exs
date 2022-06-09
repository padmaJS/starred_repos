defmodule GithubStarredRepo.Repo.Migrations.CreateStarredRepos do
  use Ecto.Migration

  def change do
    create table(:starred_repos) do
      add :name, :string
      add :description, :string
      add :language, :string
      add :github_url, :string
      add :ref_id, :integer
      timestamps()
    end
  end
end
