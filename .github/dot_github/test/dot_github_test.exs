defmodule DotGithubTest do
  use ExUnit.Case
  doctest DotGithub

  test "greets the world" do
    assert DotGithub.hello() == :world
  end
end
