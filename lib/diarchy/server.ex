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
    read(socket) |> generate_response() |> write(socket)
    :gen_tcp.shutdown(socket, :read_write)
  end

  defp read(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    Logger.info "Received #{data}"
    data
  end

  defp generate_response(data) do
    try do
      parsed_data = Diarchy.parse_request(data)
      Logger.info "Client sent #{parsed_data.data_block}"
      %Diarchy.Response{status: status, type: type, content: content} = Diarchy.read_file(parsed_data.path)
      resp = [status, type] |> Enum.filter(& & 1) |> Enum.join(" ") |> Kernel.<>("\r\n #{content}")
      Logger.info "sending #{resp}"
      resp
    rescue
      e ->
	Logger.error(Exception.format(:error, e, __STACKTRACE__))
        "5 internal server error\r\n"
    end
  end

  defp write(data, socket) do
    :gen_tcp.send(socket, data)
  end
end


