defmodule Models.GameStatus do
  defstruct status: :not_started,
            current_round: -1,
            number_rounds: 0,
            maze_width: 0,
            maze_height: 0,
            num_exits: 0
end
