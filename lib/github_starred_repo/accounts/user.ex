defmodule GithubStarredRepo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias GithubStarredRepo.Starred_repos.Starred_repo

  schema "users" do
    field :name, :string

    has_many :starred_repos, Starred_repo, on_delete: :delete_all
    timestamps()
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:name])
    |> unique_constraint([:name])
    |> validate_required([:name])
  end
end
