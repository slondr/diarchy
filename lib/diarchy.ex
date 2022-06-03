## This file is part of Diarchy, a concurrent spartan server.
## Copyright 2022 Eric S. Londres
## This program is free software: you can redistribute it and/or modiy it under the terms of the GNU Affero General
##  Public License as published by the Free Software Foundation, version 3. This program is distributed in the hope
##  that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
##  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
## You should have received a copy of the GNU Affero General Public License along with this program.
##  If not, see <https://www.gnu.org/licenses/>.

defmodule Diarchy do
  alias Diarchy.Request
  alias Diarchy.Response
 
  
  def parse_request(request) do
    [request_line, data_block] = String.split(request, "\r\n", parts: 2, trim: false)
    [host, path, content_length_string] = String.split(request_line, " ", parts: 3, trim: true)
    {content_length, _} = Integer.parse(content_length_string)
    if byte_size(data_block) != content_length, do: raise "Invalid request"
    %Request{host: host, path: String.slice(path, 1..-1), content_length: content_length, data_block: data_block}
  end

  def read_file(path) do
    # TODO: Prevent back-tracking
    # TODO: Directory listing?
    case File.read(path) do
      {:ok, contents} -> %Response{status: 2, type: "text/plain", content: contents}
      {:error, :enoent} -> %Response{status: 4, type: "file not found"}
      {:error, reason} -> %Response{status: 5, type: reason}
    end
  end
end
