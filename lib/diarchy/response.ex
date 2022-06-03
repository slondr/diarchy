defmodule Diarchy.Response do
  @enforce_keys [:status, :type]
  defstruct [:status, :type, :content]
end
