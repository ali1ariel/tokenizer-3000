defmodule TokenizerSimulator.TestesGerais do
  alias Ecto.Changeset
  alias Tokenizer.TokenManager
  alias Tokenizer.Users
  alias Tokenizer.Tokens
  @default_timer 30

  @doc """
  Prepara o sistema para testar a necessidade de serem apenas 100 tokens de limite disponível.
  """
  def teste1() do
    1..99
    |> Enum.each(fn _ -> criar_token() end)
  end

  @doc """
  Compatível com o teste 1, todos os usuários vão conseguindo seus tokens, porém os últimos vão retirando os tokens em uso dos primeiros.
  """
  def teste2() do
    1..120
    |> Enum.each(fn _ -> criar_usuario() end)

    Users.list_users()
    |> Enum.map(fn user ->
      TokenManager.assign_token(user)
      |> print_assign_response()

      Process.sleep(25)
    end)
  end

  def teste3() do
    1..5
    |> Enum.each(fn _ ->
      criar_token()
      criar_usuario()
    end)

    Users.list_users()
    |> Enum.map(fn user ->
      resp = TokenManager.assign_token(user)
      Process.sleep(div(@default_timer * 1000, 5))
      print_assign_response(resp)
    end)
  end

  def criar_usuario() do
    {:ok, user} = Users.create_user(%{name: Faker.Person.name(), email: Faker.Internet.email()})

    IO.inspect("O usuário #{user.name} foi criado com sucesso!")
    user
  end

  def criar_token() do
    case Tokens.create_token() do
      {:ok, token} ->
        IO.inspect("O token #{token.name} foi criado com sucesso!")
        nil

      {:error, %Changeset{} = changeset} ->
        IO.inspect("O token não pode ser criado, motivo: #{inspect(changeset.errors)}")
        nil
    end
  end

  defp print_assign_response({:ok, assignment}) do
    "token: #{assignment.token.name} - #{assignment.token.id}, usuário: #{assignment.user.name}, agora: #{Timex.now()}, liberação: #{assignment.expires_at}"
    |> IO.inspect()
  end
end
