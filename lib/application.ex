## This file is part of Diarchy, a concurrent spartan server.
## Copyright 2022 Eric S. Londres
## This program is free software: you can redistribute it and/or modiy it under the terms of the GNU Affero General
##  Public License as published by the Free Software Foundation, version 3. This program is distributed in the hope
##  that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
##  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
## You should have received a copy of the GNU Affero General Public License along with this program.
##  If not, see <https://www.gnu.org/licenses/>.

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
