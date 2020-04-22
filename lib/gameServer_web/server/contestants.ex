defmodule Contestants do
  use GenServer

  def start() do
    GenServer.start(__MODULE__, nil, name: get_repository_name())
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil, name: get_repository_name())
  end

  def add_contestant(contestant) do
    GenServer.cast(__MODULE__, {:add_contestant, {contestant, 0, [], [], [], 0}})
    :ets.lookup(table_name(), contestant)
  end

  def score_contestant(score_contestant = %Contestant{}) do
    round = 0 #variable not needed for production, remove when merged with Main genserver
    maze_width = 1
    maze_height = 1

    #Checks if the contestant is in the ETS table
    case :ets.lookup(table_name(), score_contestant.name) do
      [_] ->
        #Checks to see if the contestants round is the same as the current round
        cond do
          score_contestant.round == round #Replace with Maingenserver.get_round()
          ->
                #Takes the existing score for the contestant and adds teh points gotten for the current round
                #After it does that it creates a new contestant variable and sends it to the score_contestant cast
                new_score = (score_contestant.score + 1) #(Pathfinder.path_length(score_contestant.maze, score_contestant.start, score_contestant.exit))
                temp_cont = {score_contestant.name, score_contestant.round, score_contestant.maze, score_contestant.start, score_contestant.exit, new_score}
                GenServer.cast(__MODULE__, {:score_contestant, temp_cont})
          true
          ->
                #Takes the existing score for the contestant and adds a set amount of points
                #After it does that it creates a new contestant variable and sends it to the score_contestant cast
                new_score = (score_contestant.score + (maze_width * maze_height))
                temp_cont = {score_contestant.name, score_contestant.round, score_contestant.maze, score_contestant.start, score_contestant.exit, new_score}
                GenServer.cast(__MODULE__, {:score_contestant, temp_cont})
          end
      [] -> nil
    end
  end

  def get_contestants() do
    GenServer.call(__MODULE__, :get_contestants)
  end

  ###########################Server Side#################################

  @impl true
  def init(_) do
    #Initializes a new local ETS table
    :ets.new(table_name(), [:named_table, :set, :protected])
    {:ok, nil}
  end


  @impl true
  def handle_cast({:add_contestant, new_contestant = %Contestant{}}, _) do
    #Checks if the contestant exists in the table already
    case :ets.lookup(table_name(), new_contestant.name) do
      [] -> :ets.insert(table_name(), {new_contestant.name, new_contestant.round, new_contestant.maze, new_contestant.start, new_contestant.exit, new_contestant.score})
      _ -> nil
    end

    {:noreply, nil}
  end

  @impl true
  def handle_cast({:score_contestant, contestant = %Contestant{}}, _) do
    case :ets.lookup(table_name(), contestant.name) do
      [_] -> :ets.insert(table_name(), {contestant.name, contestant.round, contestant.maze, contestant.start, contestant.exit,  contestant.score})
      [] -> nil
    end

    {:noreply, nil}
  end

  @impl true
  def handle_call(:get_contestants, _, contestant_list) do
    contestant_list1 = :ets.tab2list(table_name())
    {:reply, contestant_list1, contestant_list}
  end

  def get_repository_name(), do: :Repository

  def table_name(), do: :table

end
