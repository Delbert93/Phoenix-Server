defmodule MazeGeneratorTest do
  use ExUnit.Case
  doctest(MazeGenerator)

  test "No four-way intersections" do
    %{maze: maze} = MazeGenerator.gen_maze(50, 50, 1)

    Enum.each(maze, fn cell ->
      assert Enum.count(Pathfinder.get_visitable_neighbors(cell, maze, [])) < 4
    end)



  end
end
