defmodule GameSupervisor do
  def start_link do
    Supervisor.start_link(
      [
       GameStatusGenServer,
       Web,
       MazeGameClient
      ],
      strategy: :one_for_one
    )
  end
end
