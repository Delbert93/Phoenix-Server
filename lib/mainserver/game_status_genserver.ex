defmodule GameStatusGenServer do
  use GenServer

  alias Models.GameStatus
  def start_link() do
    GenServer.start_link(__MODULE__, {false, -1, -1}, name: __MODULE__)
  end

@impl true
  def init({status, time_stamp, number_rounds}) do
      {:ok, %GameStatus{status: status, time_stamp: time_stamp, number_rounds: number_rounds}}
  end

  def handle_call() do
    #find out what needs to be waiting on and what does not. 
  end

  def handle_cast() do

  end


end
