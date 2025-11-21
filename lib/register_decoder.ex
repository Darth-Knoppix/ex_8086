defmodule RegisterDecoder do
  def data_type_to_atom(0), do: :byte
  def data_type_to_atom(1), do: :word

  def decode(type, reg) when is_integer(type) do
    type |> data_type_to_atom() |> decode(reg)
  end

  def decode(:byte, 0b000), do: "al"
  def decode(:word, 0b000), do: "ax"

  def decode(:byte, 0b001), do: "cl"
  def decode(:word, 0b001), do: "cx"

  def decode(:byte, 0b010), do: "dl"
  def decode(:word, 0b010), do: "dx"

  def decode(:byte, 0b011), do: "bl"
  def decode(:word, 0b011), do: "bx"

  def decode(:byte, 0b100), do: "ah"
  def decode(:word, 0b100), do: "sp"

  def decode(:byte, 0b101), do: "ch"
  def decode(:word, 0b101), do: "bp"

  def decode(:byte, 0b110), do: "dh"
  def decode(:word, 0b110), do: "si"

  def decode(:byte, 0b111), do: "bh"
  def decode(:word, 0b111), do: "di"

  def decode(type, reg) do
    IO.puts(:standard_error, "Unknown type: #{inspect(type)} or REG: #{inspect(reg)}")
  end
end
