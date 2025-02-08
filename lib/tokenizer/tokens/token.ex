defmodule Tokenizer.Tokens.Token do
  alias Tokenizer.Queries.Token, as: TokenQueries
  alias Tokenizer.Repo
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  schema "tokens" do
    field :available?, :boolean, default: true
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:available?])
    |> put_name(token.name)
    |> validate_required([:available?])
    |> validate_tokens_limit()
  end

  def put_name(changeset, nil) do
    changeset
    |> put_change(:name, choose_pokemon())
  end

  def put_name(changeset, _), do: changeset

  def choose_pokemon() do
    pokemon =
      Faker.Pokemon.name()

    if Repo.exists?(TokenQueries.find_token_by_pokemon_name(pokemon)) do
      choose_pokemon()
    else
      pokemon
    end
  end

  defp validate_tokens_limit(changeset) do
    case Repo.aggregate(__MODULE__, :count) do
      count when count >= 100 ->
        add_error(changeset, :base, "Limite máximo de 100 tokens atingido")

      _ ->
        changeset
    end
  end
end
