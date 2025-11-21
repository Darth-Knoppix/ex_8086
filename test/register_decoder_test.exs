defmodule RegisterDecoderTest do
  use ExUnit.Case
  doctest RegisterDecoder

  test "REG = 000, W = 0 -> AL" do
    assert RegisterDecoder.decode(0, 0b000) == "al"
  end
end
