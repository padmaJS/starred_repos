defmodule GithubStarredRepo.Starred_repos.Starred_repo do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias GithubStarredRepo.Accounts.User
  alias GithubStarredRepo.Starred_repos.Starred_repo
  alias GithubStarredRepo.StarredReposTags
  alias GithubStarredRepo.Tags.Tag

  schema "starred_repos" do
    field :description, :string
    field :github_url, :string
    field :language, :string
    field :name, :string
    field :ref_id, :integer

    belongs_to :user, User

    many_to_many :tags, Tag, join_through: StarredReposTags, on_delete: :delete_all
    timestamps()
  end

  @doc false
  def changeset(starred_repo, attrs) do
    starred_repo
    |> cast(attrs, [:name, :description, :language, :github_url, :ref_id, :user_id])
    |> unique_constraint([:ref_id])
    |> validate_required([:name, :description, :language, :github_url, :ref_id])
    |> put_assoc(:tags, parse_tags(attrs))
  end

  defp parse_tags(attrs) do
    (attrs[:tags] || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> insert_and_get_all
  end

  defp insert_and_get_all([]), do: []

  defp insert_and_get_all(names) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    maps =
      Enum.map(
        names,
        &%{
          name: &1,
          inserted_at: timestamp,
          updated_at: timestamp
        }
      )

    Repo.insert_all(Tag, maps, on_conflict: :nothing)
    Repo.all(from t in Tag, where: t.name in ^names)
  end
end
