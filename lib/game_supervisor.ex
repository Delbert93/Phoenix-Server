defmodule GameSupervisor do
  def start_link do
    Supervisor.start_link(
      [
       GameStatusGenServer,
       Web
      ],
      strategy: :one_for_one
    )
  end
end
