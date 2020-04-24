defmodule MainServer do
  use Timex

  def get_status() do

  end

  @spec get_maze :: any
  def get_maze() do
    maze = Generator.gen_maze(5, 5, 1)
  end

  def start_game() do
    maze = get_maze()
    [_, rest] = get_time_stamp
    GameStatusGenServer.start_game_genserver(True, rest, 1)
    maze
  end

  def get_time_stamp()do
    datetime = Timex.now("America/Boise")
    Timex.format!(datetime, "%FT%T%:z", :strftime)
    |> String.split("T")
  end

end
