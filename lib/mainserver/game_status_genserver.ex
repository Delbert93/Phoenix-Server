defmodule GameStatusGenServer do
  use GenServer

  # def start_link(status, time_stamp, number_stamp) do
  #   GenServer.start_link(__MODULE__, false, -1, -1)
  # end

@impl true
  def init(status, time_stamp, number_stamp) do
      {:ok, %{status: false, time_stamp: -1, number_stamp: -1}}
  end

end
