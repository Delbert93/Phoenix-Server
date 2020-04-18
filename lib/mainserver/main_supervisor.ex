defmodule MainSupervisor do
  use DynamicSupervisor

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def int([]) do
    DunamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(_) do
    # DynamicSupervisor.start_child(__MODULE__, {GameStatusGenServer, _word})
  end

  def get_children() do
    DynamicSupervisor.which_children(__MODULE__)
  end
end
