defmodule Poker.Mixfile do
  use Mix.Project

  def project do
    [app: :poker,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package,
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:markdown, github: "devinus/markdown", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
    ]
  end

  defp package do
    [
      description: "An Elixir library to work with Poker hands.",
      licenses: ["MIT"],
      maintainers: ["Wojtek Mach"],
      links: %{"GitHub" => "https://github.com/wojtekmach/poker_elixir"},
    ]
  end
end
