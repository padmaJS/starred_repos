defmodule GithubStarredRepo.Repo.Migrations.AddUserReference do
  use Ecto.Migration

  def change do
    alter table("starred_repos") do
      add :user_id, references("users", on_delete: :delete_all)
    end

    create unique_index("starred_repos", [:ref_id, :user_id])
  end
end
