defmodule GithubStarredRepo.Starred_repos do
  @moduledoc """
  The Starred_repos context.
  """

  import Ecto.Query, warn: false
  alias GithubStarredRepo.Repo

  alias GithubStarredRepo.Starred_repos.Starred_repo

  @doc """
  Returns the list of starred_repos.

  ## Examples

      iex> list_starred_repos()
      [%Starred_repo{}, ...]

  """
  def list_starred_repos do
    Repo.all(Starred_repo)
  end

  @doc """
  Gets a single starred_repo.

  Raises `Ecto.NoResultsError` if the Starred repo does not exist.

  ## Examples

      iex> get_starred_repo!(123)
      %Starred_repo{}

      iex> get_starred_repo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_starred_repo!(id), do: Repo.get!(Starred_repo, id)

  @doc """
  Creates a starred_repo.

  ## Examples

      iex> create_starred_repo(%{field: value})
      {:ok, %Starred_repo{}}

      iex> create_starred_repo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_starred_repo(attrs \\ %{}) do
    %Starred_repo{}
    |> Starred_repo.changeset(attrs)
    |> Repo.insert()
  end

  def create_starred_repos(repos) do
    Repo.insert_all(Starred_repo, repos, on_conflict: {:replace_all_except, [:id]},
    conflict_target: [:user_id, :ref_id])
  end

  @doc """
  Updates a starred_repo.

  ## Examples

      iex> update_starred_repo(starred_repo, %{field: new_value})
      {:ok, %Starred_repo{}}

      iex> update_starred_repo(starred_repo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_starred_repo(%Starred_repo{} = starred_repo, attrs) do
    starred_repo
    |> Starred_repo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a starred_repo.

  ## Examples

      iex> delete_starred_repo(starred_repo)
      {:ok, %Starred_repo{}}

      iex> delete_starred_repo(starred_repo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_starred_repo(%Starred_repo{} = starred_repo) do
    Repo.delete(starred_repo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking starred_repo changes.

  ## Examples

      iex> change_starred_repo(starred_repo)
      %Ecto.Changeset{data: %Starred_repo{}}

  """
  def change_starred_repo(%Starred_repo{} = starred_repo, attrs \\ %{}) do
    Starred_repo.changeset(starred_repo, attrs)
  end

  def map_json(%HTTPoison.Response{body: body}, user) do
    {:ok, repos} = Jason.decode(body)
    current_time = NaiveDateTime.utc_now()
                  |> NaiveDateTime.truncate(:second)
    Enum.map(repos, fn repo ->
      %{
        name: repo["name"],
        description: repo["description"],
        ref_id: repo["id"],
        github_url: repo["html_url"],
        language: repo["language"],
        user_id: user.id,
        inserted_at: current_time,
        updated_at: current_time
      }
    end)
  end

  def get_starred_repos(user) do
    user
    |> Ecto.assoc(:starred_repos)
    |> Repo.all()
  end

  # def get_starred_repos(user) do
  #   Starred_repo
  #   |> where(user_id: ^user.id)
  #   |> Repo.all()
  # end
end
