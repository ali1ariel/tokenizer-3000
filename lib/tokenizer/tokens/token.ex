defmodule Tokenizer.Tokens.Token do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  schema "tokens" do
    field :available?, :boolean, default: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:available?])
    |> validate_required([:available?])
  end
end
