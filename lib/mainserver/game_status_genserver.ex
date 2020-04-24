defmodule GameStatusGenServer do
  use GenServer

  alias Models.GameStatus
  @server_name :server
  def get_status(@server) do
    Genserver.call(@server, :get)
  end

  def start_game_genserver(status, time_stamp, number_rounds) do
    GenServer.cast(@serber, %Models.GameStatus{status: status, time_stamp: time_stamp, number_rounds: number_rounds})
  end

  def start_link() do
    GenServer.start_link(__MODULE__, {false, " ", -1}, name: __MODULE__)
  end

  @impl true
  def init({status, time_stamp, number_rounds}) do
      {:ok, %GameStatus{status: status, time_stamp: time_stamp, number_rounds: number_rounds}}
  end

  @impl true
  def handle_call(:get, _, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast(details = %Models.GameStatus{}, state) do
    new_state = [details | state]
    {:noreply, new_state}
  end


end
