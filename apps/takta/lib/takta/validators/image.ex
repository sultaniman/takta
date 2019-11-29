defmodule Takta.Image do
  @moduledoc """
  Helper functions to read the binary to determine the image extension.

  Allowed formats are:

    * PNG,
    * JPG

  Usage:

  ```
    binary_image
    |> Takta.Image.extension()
    |> Takta.Image.is_valid?()
  ```
  """
  @allowed_extensions [".png", ".jpg"]

  def extension(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _::binary>>), do: ".png"
  def extension(<<0xff, 0xD8, _::binary>>), do: ".jpg"
  def extension(_), do: nil

  def is_valid?(nil), do: false
  def is_valid?(ext), do: @allowed_extensions |> Enum.member?(ext)
end
