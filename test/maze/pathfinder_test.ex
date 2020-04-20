defmodule PathfinderTest do
  use ExUnit.Case
  doctest(Pathfinder)

  test "Path cells are in maze", %{maze: maze, path: path} do
    #Assert all path cells are within the maze
    assert Enum.all?(path, fn cell -> Enum.member?(maze, cell) end)
  end

  test "Path is continuous", %{maze: maze, path: path} do

    #Assert all cells not including the start and exit have either two or three neighbors
    Enum.each(path, fn cell ->
      num_neighbors = Enum.count(Pathfinder.get_visitable_neighbors(cell, maze, []))
      assert num_neighbors >= 2
      assert num_neighbors <= 4
    end)

  end


  setup_all do
    %{maze: maze, exits: [endpoint]} = MazeGenerator.gen_maze(50, 50, 1)

    start_point = Enum.random(maze -- [endpoint])

    {:ok, path} = Pathfinder.find_path(maze, start_point, endpoint)

   {:ok, %{maze: maze, path: path, start_point: start_point, endpoint: endpoint}}
  end
end
