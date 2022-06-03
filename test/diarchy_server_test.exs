defmodule DiarchyServerTest do
  use ExUnit.Case
  doctest Diarchy.Server

  setup_all do
    file_name = :rand.uniform() |> to_string()

    on_exit(fn ->
      File.rm(file_name)
    end)

    %{file_name: file_name}
  end
  
  test "read_file reads file", context do
    %{file_name: file_name} = context
    file_data = :rand.uniform() |> to_string()
    
    File.write!(file_name, file_data)

    assert Diarchy.Server.read_file(file_name).content == file_data

    File.rm!(file_name)
  end

  test "parse_request parses a good request" do
    parsed_request = Diarchy.Server.parse_request("example.com /path 0\r\n")
    
    assert parsed_request.host == "example.com"
    assert parsed_request.path == "path"
    assert parsed_request.content_length == 0
  end

  test "parse_request parses a good request with data" do
    parsed_request = Diarchy.Server.parse_request("example.com /path 1\r\na")

    assert parsed_request.host == "example.com"
    assert parsed_request.path == "path"
    assert parsed_request.content_length == 1
    assert parsed_request.data_block == "a"
  end
end
