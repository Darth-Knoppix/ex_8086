defmodule Decoder do
  def read(data) when is_binary(data) do
    (read_instruction(data) |> Enum.join("\n")) <> "\n"
  end

  def read_instruction("") do
    []
  end

  def read_instruction(data) when is_binary(data) do
    <<opcode::6, direction::1, operation_type::1, mode::2, register_field_a::3,
      register_field_b::3, remaining_bits::bitstring>> = data

    register_a = RegisterDecoder.decode(operation_type, register_field_a) |> String.downcase()
    register_b = RegisterDecoder.decode(operation_type, register_field_b) |> String.downcase()

    result = opcode |> opcode_to_mnemonic() |> decode(direction, mode, register_a, register_b)

    [result] ++ read_instruction(remaining_bits)
  end

  defp opcode_to_mnemonic(0b100010), do: :mov

  defp opcode_to_mnemonic(opcode) do
    IO.puts(:standard_error, "Unrecognized opcode: #{inspect(opcode)}")
  end

  defp decode(:mov, direction, _mode, register_a, register_b) do
    [target, destination] =
      if direction == 0 do
        [register_a, register_b]
      else
        [register_b, register_a]
      end

    "mov #{destination}, #{target}"
  end
end
