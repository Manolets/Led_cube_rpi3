defmodule LedCubeRpi3.CubeSupervisor do
  use Supervisor

  def start_link(args \\ []) do
    Supervisor.start_link(__MODULE__, [args], name: __MODULE__)
  end

  def init([_args]) do
    children = [
      {Registry, keys: :unique, name: :cube_registry},
      worker(LedCubeRpi3.Fns, [], id: :ox20)
    ]

    for n <- [5, 6, 13, 19], do: Pigpiox.GPIO.set_mode(n, :output)

    Supervisor.init(children, strategy: :one_for_all)
  end
end
