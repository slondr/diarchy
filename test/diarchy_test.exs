defmodule DiarchyTest do
  use ExUnit.Case
  doctest Diarchy

  test "greets the world" do
    assert Diarchy.hello() == :world
  end
end
