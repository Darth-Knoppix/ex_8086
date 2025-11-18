defmodule DecoderTest do
  use ExUnit.Case
  doctest Decoder

  describe "single instruction" do
    test "mov instruction is decoded" do
      assert Decoder.read(<<0x89, 0xD9>>) == "mov cx, bx\n"
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
  end
end
