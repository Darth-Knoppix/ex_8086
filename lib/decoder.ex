defmodule Decoder do
  def read(data) do
    (read_instruction(data) |> Enum.join("\n")) <> "\n"
  end

  def read_instruction(<<opcode::8, remaining_bits::bitstring>>) do
    {operation, meta} = opcode_to_mnemonic(<<opcode>>)

    {decoded_instruction, remaining_bits} = decode(operation, meta, remaining_bits)
    [decoded_instruction] ++ read_instruction(remaining_bits)
  end

  def read_instruction(""), do: []
  def read_instruction(_), do: []

  #
  # Register/memory to/from register
  defp opcode_to_mnemonic(<<0b100010::6, direction::1, type::1>>) do
    {:mov,
     %{direction: direction_to_atom(direction), type: RegisterDecoder.data_type_to_atom(type)}}
  end

  # Immediate to register/memory
  defp opcode_to_mnemonic(<<0b1100011::7, type::1>>) do
    {:mov, %{type: RegisterDecoder.data_type_to_atom(type)}}
  end

  # Immediate to register
  defp opcode_to_mnemonic(<<0b1011::4, type::1, register::3>>) do
    {:mov,
     %{
       type: RegisterDecoder.data_type_to_atom(type),
       register: RegisterDecoder.decode(type, register)
     }}
  end

  # Memory to accumulator
  defp opcode_to_mnemonic(<<0b101000::6, type::1>>) do
    {:mov, %{type: RegisterDecoder.data_type_to_atom(type), direction: :accumulator}}
  end

  # Accumulator to memory
  defp opcode_to_mnemonic(<<0b1010001::7, type::1>>) do
    {:mov, %{type: RegisterDecoder.data_type_to_atom(type), direction: :memory}}
  end

  # Register/memory to segment register
  defp opcode_to_mnemonic(<<0b10001110::8>>) do
    {:mov, %{}}
  end

  # Segment register to register/memory
  defp opcode_to_mnemonic(<<0b10001100::8>>) do
    {:mov, %{}}
  end

  defp opcode_to_mnemonic(opcode) do
    IO.puts(:standard_error, "Unrecognized opcode: #{Integer.to_string(opcode, 2)}")
  end

  defp direction_to_atom(0), do: :to
  defp direction_to_atom(1), do: :from

  defp decode(:mov, %{direction: direction, type: type}, data) do
    <<_mode::2, register_field_a::3, register_field_b::3, data::bitstring>> = data

    register_a = RegisterDecoder.decode(type, register_field_a)
    register_b = RegisterDecoder.decode(type, register_field_b)

    [target, destination] =
      if direction == :to do
        [register_b, register_a]
      else
        [register_a, register_b]
      end

    instruction =
      "mov #{target}, #{destination}"

    {instruction, data}
  end

  defp decode(:mov, %{type: type, register: register}, data) do
    {value, data} =
      case type do
        :byte ->
          <<value::8, rest::bitstring>> = data
          {value, rest}

        :word ->
          <<low_value::8, high_value::8, rest::bitstring>> = data
          <<combined::16>> = <<high_value, low_value>>
          {combined, rest}
      end

    instruction = "mov #{register}, #{value}"

    {instruction, data}
  end

  defp decode(:mov, meta, data) do
    IO.inspect(meta, label: "meta")
    {"; unknown instruction", data}
  end
end
