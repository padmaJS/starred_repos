defmodule GithubStarredRepo.Starred_repos.Starred_repo do
  use Ecto.Schema
  import Ecto.Changeset

  alias GithubStarredRepo.Accounts.User

  schema "starred_repos" do
    field :description, :string
    field :github_url, :string
    field :language, :string
    field :name, :string
    field :ref_id, :integer

    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(starred_repo, attrs) do
    starred_repo
    |> cast(attrs, [:name, :description, :language, :github_url, :ref_id, :user_id])
    |> unique_constraint([:ref_id])
    |> validate_required([:name, :description, :language, :github_url, :ref_id])
  end
end
