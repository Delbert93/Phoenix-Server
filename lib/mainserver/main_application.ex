defmodule MainApplication do
  use Application

  def start(_, _) do
    children = [
      %{
        id: GameStatusGenServer,
        start: {GameStatusGenServer, :start_link, []}
      }
    ]
    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
