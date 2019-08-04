defmodule LedCubeRpi3.Fns do
  require Logger

  def start_link() do
    GenServer.start_link(LedCubeRpi3.Server, [], name: via_tuple(:cube_server))
  end

  def via_tuple(name), do: {:via, Registry, {:cube_registry, name}}
end
