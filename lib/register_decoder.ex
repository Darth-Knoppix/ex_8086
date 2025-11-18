defmodule RegisterDecoder do
  def to_byte_word_atom(0), do: :byte
  def to_byte_word_atom(1), do: :word

  def decode(type, reg) when is_integer(type) do
    type |> to_byte_word_atom() |> decode(reg)
  end

  def decode(:byte, 0b000), do: "AL"
  def decode(:word, 0b000), do: "AX"

  def decode(:byte, 0b001), do: "CL"
  def decode(:word, 0b001), do: "CX"

  def decode(:byte, 0b010), do: "DL"
  def decode(:word, 0b010), do: "DX"

  def decode(:byte, 0b011), do: "BL"
  def decode(:word, 0b011), do: "BX"

  def decode(:byte, 0b100), do: "AH"
  def decode(:word, 0b100), do: "SP"

  def decode(:byte, 0b101), do: "CH"
  def decode(:word, 0b101), do: "BP"

  def decode(:byte, 0b110), do: "DH"
  def decode(:word, 0b110), do: "SI"

  def decode(:byte, 0b111), do: "BH"
  def decode(:word, 0b111), do: "DI"

  def decode(type, reg) do
    IO.puts(:standard_error, "Unknown type: #{inspect(type)} or REG: #{inspect(reg)}")
  end
end
