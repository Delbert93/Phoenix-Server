defmodule Contestants do
  use GenServer

  def start() do
    GenServer.start(__MODULE__, nil, name: get_repository_name())
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil, name: get_repository_name())
  end

  def add_contestant(contestant) do
    GenServer.cast(__MODULE__, {:add_contestant, {contestant, "1a2b3c"}})
  end

  def get_contestants() do
    GenServer.call(__MODULE__, :get_contestants)
  end

  ###########################Server Side#################################

  @impl true
  def init(_) do
    :ets.new(table_name(), [:named_table, :set, :protected])
    {:ok, nil}
  end


  @impl true
  def handle_cast({:add_contestant, new_contestant = %Contestant{}}, _) do
    case :ets.lookup(table_name(), new_contestant.name) do
      [] -> :ets.insert(table_name(), {new_contestant.name, })
      _ -> nil
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
