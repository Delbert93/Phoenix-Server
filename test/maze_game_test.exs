defmodule MazeGameTest do
  use ExUnit.Case
  doctest MazeGame

  test "greets the world" do
    assert MazeGame.hello() == :world
  end
end
