defmodule MazeSolver do
  def get_all_paths(maze, exits, starting_point) do
    Enum.map(exits, &Pathfinder.find_path(maze, starting_point, &1))
  end

  def solve(maze, exits) do
    solve(maze, maze, exits)
  end

  #If all cells have been tested, do nothing
  def solve(_maze, _untested_cells = [], _exits) do end

  def solve(maze, untested_cells, exits) do
    starting_point = Enum.random(untested_cells)

    #Get all paths, count each path's length, sum all path lengths
    cumulative_path_length =
    get_all_paths(maze, exits, starting_point)
    #|> IO.inspect()
    |> Enum.map( fn {:ok, path} -> Enum.count(path) end)
    |> Enum.sum

    StartingPointServer.evaluate_point(starting_point, cumulative_path_length)

    solve(maze, untested_cells -- [starting_point], exits)
  end
end
