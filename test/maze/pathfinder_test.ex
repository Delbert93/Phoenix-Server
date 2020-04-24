defmodule PathfinderTest do
  use ExUnit.Case
  doctest(Pathfinder)

  test "Path cells are in maze", %{maze: maze, path: path} do
    #Assert all path cells are within the maze
    assert Enum.all?(path, fn cell -> Enum.member?(maze, cell) end)
  end

  test "Path is continuous", %{maze: maze, path: path, start_point: start_point, endpoint: endpoint} do

    #Assert all cells not including the start and exit have either two or three neighbors
    Enum.each(path -- ([start_point] ++ [endpoint]), fn cell ->
      num_neighbors =  Enum.count(Pathfinder.get_visitable_neighbors(cell, maze, []))
      assert num_neighbors >= 2
      assert num_neighbors <= 3
    end)

    assert Enum.count(Pathfinder.get_visitable_neighbors(start_point, maze, [])) == 1
    assert Enum.count(Pathfinder.get_visitable_neighbors(endpoint, maze, [])) == 1
  end


  setup_all do
    %{maze: maze, exits: [endpoint]} = MazeGenerator.gen_maze(10, 10, 1)

    start_point = Enum.random(maze -- exits)

    {:ok, path} = Pathfinder.find_path(maze, start_point, endpoint)

   {:ok, %{maze: maze, path: path, start_point: start_point, endpoint: endpoint}}
  end
end
