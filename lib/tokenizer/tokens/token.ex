defmodule Tokenizer.Tokens.Token do
  alias Tokenizer.Tokens.Token
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
    |> put_name()
    |> validate_required([:available?])
  end

  def put_name(changeset) do
    changeset
    |> put_change(:name, choose_pokemon())
  end

  def choose_pokemon() do
    pokemon = Faker.Pokemon.name()

    if !Repo.exists?(Token, name: pokemon) do
      choose_pokemon()
    else
      pokemon
    end
  end
end
