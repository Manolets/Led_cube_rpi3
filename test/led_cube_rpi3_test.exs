defmodule LedCubeRpi3Test do
  use ExUnit.Case
  doctest LedCubeRpi3

  test "greets the world" do
    assert LedCubeRpi3.hello() == :world
  end
end
