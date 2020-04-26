defmodule ContestantsTable do

  def start() do
    :ets.new(table_name(), [:named_table, :set, :public])
  end


  def add_contestant(contestant_name) do
    case :ets.lookup(table_name(), contestant_name) do
      [] -> :ets.insert(table_name(), {contestant_name, 0})
      _ -> nil
    end
  end


  def score_answer(contestant, answer_round, start_point) do

    %Models.GameStatus{status: status, maze_width: maze_width, maze_height: maze_height, current_round: current_round} = GameStatusGenServer.get_state()

    if status == :in_progress do
      case :ets.lookup(table_name(), contestant) do
        [{^contestant, score}] ->
          #Checks to see if the contestants round is the same as the current round
          %{maze: maze, true_exit: true_exit} = MazeGenerator.get_maze(current_round)

          answer_score =
          if answer_round == current_round do
            Pathfinder.path_length(maze, start_point, true_exit)
          else
            maze_width * maze_height
          end

          :ets.insert(table_name(), {contestant, score + answer_score})

        [] -> nil
      end
    end


  end



  def get_contestants() do
    :ets.tab2list(table_name())
  end

  def get_repository_name(), do: :Repository

  def table_name(), do: :table

  ###########################Server Side#################################


  # @impl true
  # def init(_) do
  #   #Initializes a new local ETS table
  #   :ets.new(table_name(), [:named_table, :set, :protected])
  #   {:ok, nil}
  # end





  # @impl true
  # def handle_cast({:add_contestant, contestant}, _) do
  #   #Checks if the contestant exists in the table already
  #   case :ets.lookup(table_name(), contestant) do
  #     [] -> :ets.insert(table_name(), {contestant, 0})
  #     _ -> nil
  #   end

  #   {:noreply, nil}
  # end




  # @impl true
  # def handle_cast({:score_contestant, contestant, new_score}, _) do
  #   #Checks if the contestant exists in the ETS table, if it does update it with the new value given
  #   #If it doesn't do nothing
  #   case :ets.lookup(table_name(), contestant) do
  #     [_] -> :ets.insert(table_name(), {contestant, new_score})
  #     [] -> nil
  #   end

  #   {:noreply, nil}
  # end




  # @impl true
  # def handle_call(:get_contestants, _, contestant_list) do
  #   #Returns the list of contestants
  #   contestant_list1 = :ets.tab2list(table_name())
  #   {:reply, contestant_list1, contestant_list}
  # end



end
