defmodule StartingPointServer do
  use GenServer

  @impl true
  def init(_init_arg) do
    {:ok, {nil, nil}}
  end


  @impl true
  def handle_call(:reset, _from, _state) do
    {:reply, :ok, {nil, nil}}
  end


  @impl true
  def handle_call(:get_top_point, _from, {top_point = %Cell{}, top_point_score}) do
    {:reply, top_point, {top_point, top_point_score}}
  end


  @impl true
  def handle_cast({:evaluate, {new_point, new_point_score}}, {top_point, top_point_score}) do
      if top_point == nil || top_point_score > new_point_score do
        {:noreply, {new_point, new_point_score}}
      else
        {:noreply, {top_point, top_point_score}}
    end
  end

  @impl true
  def handle_cast(:reset, _state) do
    {:noreply, {nil, nil}}
  end


  #--------------------------------------------------------------------------------------------------------------
  def start do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end


  def reset do
    GenServer.cast(__MODULE__, :reset)
  end

  def evaluate_point(new_point, new_point_score) do
    GenServer.cast(__MODULE__, {:evaluate, {new_point, new_point_score}})
  end

  def get_top_point() do
    case GenServer.call(__MODULE__, :get_top_point) do
      nil ->
        {:error, :no_points_evaluated}

      top_point = %Cell{} ->
        {:ok, top_point}
    end
  end

end
