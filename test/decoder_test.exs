defmodule DecoderTest do
  use ExUnit.Case
  doctest Decoder

  describe "single instruction" do
    test "mov instruction is decoded" do
      assert Decoder.read(<<0b10001001, 0b11011001>>) == "mov cx, bx\n"
    end

    test "8-bit immediate-to-register mov" do
      assert Decoder.read(<<0b10110001, 0b00001100>>) == "mov cl, 12\n"
    end

    test "16-bit immediate-to-register mov" do
      assert Decoder.read(<<0b10111010, 0b01101100, 0b00001111>>) == "mov dx, 3948\n"
    end
  end

  describe "multiple instructions" do
    test "multiple move instructions are decoded" do
      assert Decoder.read(
               <<0x89, 0xD9, 0x88, 0xE5, 0x89, 0xDA, 0x89, 0xDE, 0x89, 0xFB, 0x88, 0xC8, 0x88,
                 0xED, 0x89, 0xC3, 0x89, 0xF3, 0x89, 0xFC, 0x89, 0xC5>>
             ) == """
             mov cx, bx
             mov ch, ah
             mov dx, bx
             mov si, bx
             mov bx, di
             mov al, cl
             mov ch, ch
             mov bx, ax
             mov bx, si
             mov sp, di
             mov bp, ax
             """
    end

    test "multiple 16-bit immediate-to-register mov" do
      assert Decoder.read(
               <<0b10111001, 0b00001100, 0b00000000, 0b10111001, 0b11110100, 0b11111111,
                 0b10111010, 0b01101100, 0b00001111, 0b10111010, 0b10010100, 0b11110000>>
             ) == """
             mov cx, 12
             mov cx, 65524
             mov dx, 3948
             mov dx, 61588
             """
    end
  end
end
