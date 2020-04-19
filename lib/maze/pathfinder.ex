defmodule Pathfinder do

  def path_length(maze, starting_point = %Cell{}, endpoint = %Cell{} ) do
    find_path(maze, starting_point, endpoint)
    |> case do
      {:ok, path} -> Enum.count(path)
      {:error, :no_path} -> {:error, :no_path}
    end
  end


  def find_path(maze, starting_point, endpoint) do
    find_path(maze, [starting_point], [starting_point], endpoint)
  end

  def find_path(maze, [path_head | path_tail] = path, visited_cells, endpoint) do
    neighbors = get_visitable_neighbors(path_head, maze, visited_cells)

    cond do
      #If the endpoint has been reached, return the path
      path_head == endpoint ->
        {:ok, path}

      #If there are visitable neighbors and the endpoint hasn't been reached, pick a random neighbor and move to it
      neighbors != [] ->
        next_tile = Enum.random(neighbors)
        find_path(maze, [next_tile] ++ path, [next_tile] ++ visited_cells, endpoint)

      #If there are no visitable neighbors but there are still cells to backtrack to, backtrack
      path_tail != [] ->
        find_path(maze, path_tail, visited_cells, endpoint)

      #If there are no visitable neighbors and no cells to backtrack to, then there is no path
      true ->
        {:error, :no_path}


    end
  end

  def get_visitable_neighbors(check_cell = %Cell{}, maze, visited_cells) do
    [%Cell{x: check_cell.x - 1, y: check_cell.y},
     %Cell{x: check_cell.x + 1, y: check_cell.y},
     %Cell{x: check_cell.x, y: check_cell.y + 1},
     %Cell{x: check_cell.x, y: check_cell.y - 1}]
    |> Enum.filter(fn neighbor -> Enum.member?(maze, neighbor) && !Enum.member?(visited_cells, neighbor) end)
  end

end
