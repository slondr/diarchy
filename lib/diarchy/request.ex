defmodule Diarchy.Request do
  @enforce_keys [:host, :path, :content_length]
  defstruct [:host, :path, :content_length, :data_block]
end
