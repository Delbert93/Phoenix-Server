defmodule MazeGenerator do

  @table_name :mazes_table

  def get_maze(maze_index) do
    :ets.lookup(@table_name, maze_index)
    |>
    case do
      [{_maze_index, maze}] -> maze
      [] -> {:error, "Maze #{maze_index} does not exist"}
    end
  end



  def generate_mazes(num_mazes, maze_width, maze_height, num_exits) do
    #If mazes have already been generated (i.e. the table has been created), drop the ets table
    if :ets.whereis(@table_name) != :undefined do
      :ets.delete(@table_name)
    end

    :ets.new(@table_name, [:named_table, :set, :public])

    #For each maze, start a process that generates a maze and inserts it into the ets
    Enum.map(1..num_mazes, fn maze_index ->
      Task.async( fn -> :ets.insert(@table_name, {maze_index, gen_maze(maze_width, maze_height, num_exits)}) end)
    end)
    |> Enum.each(&Task.await/1)

  end



  def gen_maze(maze_width, maze_height, num_exits) do
    maze = trace_path([%Cell{x: 0, y: 0}], [%Cell{x: 0, y: 0}], maze_width, maze_height)
    %{maze: maze, exits: Enum.take_random(maze, num_exits)}
  end



  def trace_path([path_head | path_tail ] = path, visited_cells, maze_width, maze_height) do

    visitable_neighbors = get_visitable_neighbors(path_head, visited_cells, maze_width, maze_height)

    cond do
      #If there are no visitable neighbors and the path has been traced back to its origin, return
      visitable_neighbors == [] && path_tail == [] ->
        #IO.puts("Returning maze")
        visited_cells

      #If no adjacent cells are visitable but the path hasn't been traced back to its origin, backtrack
      visitable_neighbors == [] ->
        #IO.puts("Backtracking")
        trace_path(path_tail, visited_cells, maze_width, maze_height)

      #If the two previous conditions haven't been met, then choose a random visitable neighbor, push it
      #on to path and visitable cells "stacks" and continue to pathfind from that neighboring cell
      true ->
        next_cell = Enum.random(visitable_neighbors)
        #IO.puts("Moving to cell x: #{next_cell.x}, y: #{next_cell.y}")
        trace_path([next_cell] ++ path, [next_cell] ++ visited_cells, maze_width, maze_height)
    end

  end




   # Return any cells adjacent to the given cell that have not been visited, and doesn't connect to another visited cell
  #
  # x = wall, o = visited, C = cell being checked for neighbors
  #
  # The cell to the right of the cell we're checking is returned as a valid neighbor because it hasn't been visited and
  # and none of the other cells it's connected to have been visited
  #
  #  o o x x
  #  o x x x
  #  o C x x
  #  o x x x
  #  o o x x

  def get_visitable_neighbors(cell, visited_cells, maze_width, maze_height) do

    neighbors = get_neighbors(cell, maze_width, maze_height)

    Enum.filter(neighbors, &can_visit?(cell, &1, visited_cells, maze_width, maze_height))

  end




  #Return directly adjacent cells that are within the bounds of the maze
  def get_neighbors(check_cell = %Cell{}, maze_width, maze_height) do

    neighbors = [%Cell{x: check_cell.x + 1, y: check_cell.y},
                 %Cell{x: check_cell.x - 1, y: check_cell.y},
                 %Cell{x: check_cell.x, y: check_cell.y + 1},
                 %Cell{x: check_cell.x, y: check_cell.y - 1}]

    Enum.filter(neighbors, fn neighbor -> neighbor.x >= 0 &&
                                          neighbor.x < maze_width &&
                                          neighbor.y >= 0 &&
                                          neighbor.y < maze_height end)

  end




  #Returns true if the cell hasn't been visited and is not adjacent to any visited cells
  def can_visit?(from_cell, to_cell, visited_cells, maze_width, maze_height) do

    visited_cells = visited_cells -- [from_cell]

    !Enum.any?([to_cell] ++ get_neighbors(to_cell, maze_width, maze_height), &Enum.member?(visited_cells, &1) )

  end


end
