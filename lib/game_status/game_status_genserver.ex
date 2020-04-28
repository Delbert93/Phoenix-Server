defmodule GameStatusGenServer do
  use GenServer

  alias Models.GameStatus

  @round_time_interval_ms 2000

  def child_spec(_args) do
    %{id: __MODULE__, start: {__MODULE__, :start_link, []}}
  end


  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end


  def get_status() do
    GenServer.call(__MODULE__, :get_status)
  end


  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end




  def start_game(num_rounds, maze_width, maze_height, num_exits) do
    MazeGenerator.generate_mazes(num_rounds, maze_width, maze_height, num_exits)
    GenServer.cast(__MODULE__,{:start_game, %GameStatus{status: :in_progress,
                                                        current_round: 0,
                                                        number_rounds: num_rounds,
                                                        maze_width: maze_width,
                                                        maze_height: maze_height,
                                                        num_exits: num_exits}
                              }
                  )
    next_round()
  end


  def next_round() do
    #Tell the genserver to start a new round. If the game isn't over and the genserver does start a new round,
    #call this function again after @round_time_interval_ms to start the next round. If the game is over and
    #the genserver didn't start a new round, do nothing
    case GenServer.call(__MODULE__, :next_round) do
      :ok ->
        :timer.apply_after(@round_time_interval_ms, __MODULE__, :next_round, [])

      _ ->
        nil

    end
  end


  ###########################################################################################################
  #Callbacks
  ###########################################################################################################

  @impl true
  def init(_args) do
    ContestantsTable.start()
   # MazeGenerator.generate_mazes(num_mazes, maze_width, maze_height, num_exits)
    {:ok, %GameStatus{status: :not_started, current_round: -1, number_rounds: -1, }}

  end



  @impl true
  def handle_call(:get_status, _, state) do
    %GameStatus{status: status, current_round: current_round} = state

    case status do
      :not_started ->
        {:reply, %{status: :not_started}, state}

      :in_progress ->
        %{maze: maze, exits: exits} =  Map.delete(MazeGenerator.get_maze(current_round), :true_exit)
        {:reply,  %{status: :in_progress, current_round: current_round, maze: maze, exits: exits}, state}

      :game_over ->
        score_board = ContestantsTable.get_contestants()
        |> Enum.map(fn {name, score} -> %{name: name, score: score} end)
        |> Enum.sort_by(&Map.get(&1, :score))
        {:reply, %{status: :game_over, scores: score_board}, state}

    end
  end


  @impl true
  def handle_call(:get_state, _, state) do
    {:reply, state, state}
  end


  @impl true
  def handle_call(:next_round, _, state) do
    %GameStatus{current_round: current_round, number_rounds: number_rounds} = state

    if (current_round < number_rounds) do
      IO.puts(current_round + 1)
      {:reply, :ok, %{state | current_round: current_round + 1}}
    else
      IO.puts("Game over")
      {:reply, :game_over, %{state | status: :game_over}}
    end
  end




  @impl true
  def handle_cast({:start_game, state}, _state) do
    {:noreply, state}
  end


end
