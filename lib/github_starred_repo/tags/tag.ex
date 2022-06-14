defmodule GithubStarredRepo.Tags.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  alias GithubStarredRepo.Starred_repos.Starred_repo
  alias GithubStarredRepo.StarredReposTags

  schema "tags" do
    field :name, :string

    many_to_many :starred_repos, Starred_repo, join_through: StarredReposTags, on_delete: :delete_all
    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
