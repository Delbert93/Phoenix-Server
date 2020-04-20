defmodule MazeGeneratorTest do
  use ExUnit.Case
  doctest(MazeGenerator)

  test "Cells have 1-4 neighbors" do
    %{maze: maze} = MazeGenerator.gen_maze(50, 50, 1)

    Enum.each(maze, fn cell ->
      num_neighbors = Enum.count(Pathfinder.get_visitable_neighbors(cell, maze, []))
      assert num_neighbors <= 4
      assert num_neighbors >= 1
    end)



  end
end
