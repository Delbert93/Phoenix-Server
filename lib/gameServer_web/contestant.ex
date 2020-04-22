defmodule Contestant do
  # ~w will create a list of words, the a at the end means it will actually create a list of atoms.
  # this is the same thing as saying defstruct [:Name, :Round, :Maze, :Start, :Exit, :Score]
  defstruct ~w(Name Round Maze Start Exit Score)a
end
