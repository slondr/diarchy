## This file is part of Diarchy, a concurrent spartan server.
## Copyright 2022 Eric S. Londres
## This program is free software: you can redistribute it and/or modiy it under the terms of the GNU Affero General
##  Public License as published by the Free Software Foundation, version 3. This program is distributed in the hope
##  that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
##  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
## You should have received a copy of the GNU Affero General Public License along with this program.
##  If not, see <https://www.gnu.org/licenses/>.

defmodule Diarchy.Request do
  @enforce_keys [:host, :path, :content_length]
  defstruct [:host, :path, :content_length, :data_block]
end
