defmodule TokenizerSimulator do
  alias TokenizerSimulator.TesteLoop
  alias TokenizerSimulator.TestesGerais
  @default_timer 30

  def teste1(), do: TestesGerais.teste1()
  def teste2(), do: TestesGerais.teste2()
  def teste3(), do: TestesGerais.teste3()
  def iniciar_loop(), do: TesteLoop.iniciar()

  @doc """
  Define o timer  dos testes gerais
  """
  def aplicar_cenario() do
    Application.put_env(:tokenizer, :release_timer, @default_timer)
  end
end
