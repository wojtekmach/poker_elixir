defmodule Poker do
  @moduledoc """
  An Elixir library to work with Poker hands.

  Source: <https://github.com/wojtekmach/poker_elixir>

  Documentation: <http://hexdocs.pm/poker/>

  ## Example

  ```elixir
  hand1 = "As Ks Qs Js Ts"
  hand2 = "Ac Ad Ah As Kc"

  Poker.hand_rank(hand1) # => {:straight_flush, :A}
  Poker.hand_rank(hand2) # => {:four_of_a_kind, :A, :K}

  Poker.hand_compare(hand1, hand2) # => 1
  ```
  """

  @doc """
  Returns the best rank & hand out of hole cards and community cards.

      iex> Poker.best_hand("4c 5d", "3c 6c 7d Ad Ac")
      {{:straight, 7}, {{7,:d}, {6,:c}, {5,:d}, {4,:c}, {3,:c}}}
  """
  def best_hand(hole_cards, community_cards) when is_binary(hole_cards) do
    best_hand(parse_hand(hole_cards), community_cards)
  end
  def best_hand(hole_cards, community_cards) when is_binary(community_cards) do
    best_hand(hole_cards, parse_hand(community_cards))
  end
  def best_hand(hole_cards, community_cards) do
    hole_cards = Tuple.to_list(hole_cards)
    community_cards = Tuple.to_list(community_cards)

    cards = hole_cards ++ community_cards
    hand = comb(5, cards)
    |> Enum.sort_by(fn cards ->
      cards |> List.to_tuple |> hand_value
    end)
    |> Enum.reverse
    |> hd
    |> List.to_tuple

    {hand_rank(hand), sort_hand(hand)}
  end

  defp comb(0, _), do: [[]]
  defp comb(_, []), do: []
  defp comb(m, [h|t]) do
    (for l <- comb(m-1, t), do: [h|l]) ++ comb(m, t)
  end

  @doc """
  Compares two poker hands and returns 1, 0 or -1 when the first hand is respectively more valuable, equally valuable or less valuable than the second hand.

      iex> Poker.hand_compare("Ac Qd Ah As Kc", "Ac Ad Ah Kc Kc")
      -1
  """
  def hand_compare(hand1, hand2) when is_binary(hand1) do
    hand_compare(parse_hand(hand1), hand2)
  end
  def hand_compare(hand1, hand2) when is_binary(hand2) do
    hand_compare(hand1, parse_hand(hand2))
  end
  def hand_compare(hand1, hand2) do
    r = hand_value(hand1) - hand_value(hand2)

    cond do
      r > 0  -> 1
      r == 0 -> 0
      r < 0  -> -1
    end
  end

  @doc """
  Returns hand value - a number than uniquely identifies a given hand.
  The bigger the number the more valuable a given hand is.

      iex> Poker.hand_value("Ac Kc Qc Jc Tc")
      8014
  """
  def hand_value(str) when is_binary(str) do
    str |> parse_hand |> hand_value
  end

  def hand_value(hand) do
    case hand_rank(hand) do
      {:straight_flush, a}        -> 8_000 + card_value(a)
      {:four_of_a_kind, _a, b}    -> 7_000 + card_value(b)
      {:full_house, a, b}         -> 6_000 + 15 * card_value(a) + card_value(b)
      {:flush, _r, a, b, c, d, e} -> 5_000 + card_value(a) + card_value(b) + card_value(c) + card_value(d) + card_value(e)
      {:straight, a}              -> 4_000 + card_value(a)
      {:three_of_a_kind, a, b, c} -> 3_000 + 15 * card_value(a) + card_value(b) + card_value(c)
      {:two_pair, a, b, c}        -> 2_000 + 15 * card_value(a) + 15 * card_value(b) + card_value(c)
      {:one_pair, a, b, c, d}     -> 1_000 + 15 * card_value(a) + card_value(b) + card_value(c) + card_value(d)
      {:high_card, a, b, c, d, e} -> card_value(a) + card_value(b) + card_value(c) + card_value(d) + card_value(e)
    end
  end

  @doc """
  Returns rank of a given hand.

      iex> Poker.hand_rank("Ac Kc Qc Jc Tc")
      {:straight_flush, :A}

      iex> Poker.hand_rank("Kc Qc Jc Tc 9c")
      {:straight_flush, :K}

      iex> Poker.hand_rank("5c 4c 3c 2c Ac")
      {:straight_flush, 5}

      iex> Poker.hand_rank("Ac Ad Ah As Kd")
      {:four_of_a_kind, :A, :K}

      iex> Poker.hand_rank("Ac Ad Ah Kc Kd")
      {:full_house, :A, :K}

      iex> Poker.hand_rank("Kc Kd Kh Ac Ad")
      {:full_house, :K, :A}

      iex> Poker.hand_rank("Ac Qc Jc Tc 9c")
      {:flush, :c, :A, :Q, :J, :T, 9}

      iex> Poker.hand_rank("Ac Kc Qc Jc Td")
      {:straight, :A}

      iex> Poker.hand_rank("Kc Qc Jc Tc 9d")
      {:straight, :K}

      iex> Poker.hand_rank("5c 4c 3c 2c Ad")
      {:straight, 5}

      iex> Poker.hand_rank("Ac Ad Ah Kc Qc")
      {:three_of_a_kind, :A, :K, :Q}

      iex> Poker.hand_rank("Ac Ad Kc Kd Qc")
      {:two_pair, :A, :K, :Q}

      iex> Poker.hand_rank("Ac Ad Kc Qc Jd")
      {:one_pair, :A, :K, :Q, :J}

      iex> Poker.hand_rank("Ac Qc Jd Td 9c")
      {:high_card, :A, :Q, :J, :T, 9}
  """
  def hand_rank(str) when is_binary(str) do
    parse_hand(str) |> hand_rank
  end

  def hand_rank(hand) do
    unless length(Tuple.to_list(hand)) == 5 do
      raise ArgumentError, "Must pass 5 cards, got: #{inspect(hand)}"
    end

    hand = sort_hand(hand)

    if is_straight(hand) do
      {{r1,_}, {r2,_}, _, _, _} = hand

      if r1 == :A && r2 == 5 do
        r = 5
      else
        r = r1
      end

      if is_flush(hand) do
        {:straight_flush, r}
      else
        {:straight, r}
      end
    else
      case hand do
        {{a,_},  {a,_},  {a,_},  {a,_},  {b,_}}  -> {:four_of_a_kind, a, b}
        {{a,_},  {a,_},  {a,_},  {b,_},  {b,_}}  -> {:full_house, a, b}
        {{a,_},  {a,_},  {b,_},  {b,_},  {b,_}}  -> {:full_house, b, a}
        {{r1,a}, {r2,a}, {r3,a}, {r4,a}, {r5,a}} -> {:flush, a, r1, r2, r3, r4, r5}
        {{a,_},  {a,_},  {a,_},  {b,_},  {c,_}}  -> {:three_of_a_kind, a, b, c}
        {{a,_},  {a,_},  {b,_},  {b,_},  {c,_}}  -> {:two_pair, a, b, c}
        {{a,_},  {a,_},  {b,_},  {c,_},  {d,_}}  -> {:one_pair, a, b, c, d}
        {{a,_},  {b,_},  {c,_},  {d,_},  {e,_}}  -> {:high_card, a, b, c, d, e}
      end
    end
  end

  defp is_straight(str) when is_binary(str) do
    str |> parse_hand |> is_straight
  end

  defp is_straight({{a,_}, {b,_}, {c,_}, {d,_}, {e,_}}) do
    (card_value(a) == card_value(b) + 1 || a == :A && b == 5) &&
      card_value(b) == card_value(c) + 1 &&
      card_value(c) == card_value(d) + 1 &&
      card_value(d) == card_value(e) + 1
  end

  defp is_flush({{_,a},{_,a},{_,a},{_,a},{_,a}}), do: true
  defp is_flush({_,_,_,_,_}),                     do: false

  defp card_value(:A), do: 14
  defp card_value(:K), do: 13
  defp card_value(:Q), do: 12
  defp card_value(:J), do: 11
  defp card_value(:T), do: 10
  defp card_value(i) when is_integer(i) and i >= 2 and i <= 9, do: i

  @doc """
  Accepts a string and returns a tuple of cards. A card is a tuple of rank and suit.

      iex> Poker.parse_hand("Ac Kd")
      {{:A, :c}, {:K, :d}}
  """
  def parse_hand(str) do
    str
    |> String.split(" ")
    |> Enum.map(&parse_card/1)
    |> List.to_tuple
  end

  defp parse_card(str) do
    [rank, suit] = String.codepoints(str)
    {parse_rank(rank), String.to_atom(suit)}
  end

  defp parse_rank("A"), do: :A
  defp parse_rank("K"), do: :K
  defp parse_rank("Q"), do: :Q
  defp parse_rank("J"), do: :J
  defp parse_rank("T"), do: :T
  defp parse_rank(str), do: String.to_integer(str)

  defp sort_hand(hand) do
    hand
    |> Tuple.to_list
    |> Enum.sort_by(fn {rank,_} -> card_value(rank) end)
    |> Enum.reverse
    |> List.to_tuple
  end
end
