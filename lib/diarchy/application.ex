defmodule Diarchy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    port = (System.get_env("PORT") || "3000") |> String.to_integer()
    
    children = [
      # Starts a worker by calling: Diarchy.Worker.start_link(arg)
      # {Diarchy.Worker, arg}
      {Task.Supervisor, name: Diarchy.ServerSupervisor},
      Supervisor.child_spec({Task, fn -> Diarchy.Server.accept(port) end}, restart: :permanent)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Diarchy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
