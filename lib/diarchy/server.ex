defmodule Diarchy.Server do
  @moduledoc "Network interface code"

  require Logger
  
  def accept(port) do
    {:ok, socket } = :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])
    Logger.info "Now listening on port #{port}"
    loop(socket)
  end

  defp loop(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(Diarchy.ServerSupervisor, fn -> serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid) 
   loop(socket)
  end

  defp serve(socket) do
    socket |> read() |> write(socket)
    :gen_tcp.shutdown(socket, :read_write)
  end

  defp read(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    Logger.info "Received #{data}"

    parsed_data = Diarchy.parse_request(data)
    Logger.info "Client sent #{parsed_data.data_block}"
    file_contents = Diarchy.read_file(parsed_data.path)

    # Todo
    response = "2 application/octet-stream\r\n" <> file_contents
    
    response
  end

  defp write(data, socket) do
    :gen_tcp.send(socket, data)
  end
end


