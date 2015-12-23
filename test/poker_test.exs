defmodule PokerTest do
  use ExUnit.Case
  doctest Poker

  test "hand rank is calculated even when cards aren't sorted" do
    assert Poker.hand_rank("Ac 2c 3c 4c 5d") == {:straight, :"5"}
    assert Poker.hand_rank("5c 4c 3c 2c Ad") == {:straight, :"5"}
  end
end
