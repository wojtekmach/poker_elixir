# Poker

[![Build Status](https://travis-ci.org/wojtekmach/poker_elixir.svg)](https://travis-ci.org/wojtekmach/poker_elixir)

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

## Installation

  1. Add poker to your list of dependencies in `mix.exs`:

        def deps do
          [{:poker, "~> 0.0.1"}]
        end

  2. Ensure poker is started before your application:

        def application do
          [applications: [:poker]]
        end

## License

The MIT License (MIT)

Copyright (c) 2015-2016 Wojciech Mach

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
