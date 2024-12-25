defmodule GhagenTest do
  use ExUnit.Case
  doctest Ghagen

  test "greets the world" do
    assert Ghagen.hello() == :world
  end
end
