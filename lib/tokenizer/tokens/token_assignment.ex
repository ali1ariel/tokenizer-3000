defmodule Tokenizer.Tokens.TokenAssignment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tokenizer.Tokens.Token
  alias Tokenizer.Users.User

  schema "token_assignments" do
    field :expires_at, :utc_datetime

    belongs_to :token, Token, type: :binary_id
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(token_assignment, attrs) do
    token_assignment
    |> cast(attrs, [:token_id, :user_id, :expires_at])
    |> cast_assoc(:user)
    |> cast_assoc(:token)
    |> put_expiration_date()
    |> validate_required([:token_id, :user_id])
    |> foreign_key_constraint(:token_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:token_id, name: :unique_active_token_assignment)
    |> unique_constraint(:user_id, name: :unique_active_user_assignment)
  end

  defp put_expiration_date(changeset) do
    changeset
    |> put_change(:expires_at, define_expiration_time())
  end

  defp define_expiration_time() do
    DateTime.utc_now()
    |> Timex.shift(minutes: 2)
    |> DateTime.truncate(:second)
  end
end
