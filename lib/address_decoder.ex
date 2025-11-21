defmodule AddressDecoder do
  def decode(0b000), do: ["bx", "si"]
  def decode(0b001), do: ["bx", "di"]
  def decode(0b010), do: ["bp", "si"]
  def decode(0b011), do: ["bp", "di"]
  def decode(0b100), do: ["si"]
  def decode(0b101), do: ["di"]
  def decode(0b110), do: ["bp"]
  def decode(0b111), do: ["bx"]

  def decode(reg) do
    IO.puts(
      :standard_error,
      "Unknown REG: #{Integer.to_string(reg)}"
    )
  end

  def join_with_adder(parts) do
    body = parts |> Enum.reject(&(&1 == 0)) |> Enum.join(" + ")
    "[" <> body <> "]"
  end
end
