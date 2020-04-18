defmodule MainServer do

  def get_status() do

  end

  @spec get_maze :: any
  def get_maze() do
    maze = Generator.generate_mazes(1, 5, 5, 1)
    IO.inspect(maze)
  end

  def start_game(_maze_width, _maze_height, _num_exits, _num_rounds) do

  end

end
