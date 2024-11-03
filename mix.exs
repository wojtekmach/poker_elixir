defmodule Poker.Mixfile do
  use Mix.Project

  @version "0.1.0-dev"
  @source_url "https://github.com/wojtekmach/poker_elixir"

  def project do
    [
      app: :poker,
      version: @version,
      elixir: "~> 1.1",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        source_url: @source_url,
        source_ref: "v#{@version,
        readme: "README.md",
        main: "Poker"]
      end,
      description: "An Elixir library to work with Poker hands.",
      package: package()
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.34", only: :dev}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      maintainers: ["Wojtek Mach"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
