defmodule LedCubeRpi3.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.target()

  use Application
  # alias LedCubeRpi3.CubeSupervisor, as: CubeSupervisor

  def start(_type, _args) do
    # import Supervisor.Spec
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LedCubeRpi3.Supervisor]

    children =
      [
        # supervisor(CubeSupervisor, [], id: make_ref(), restart: :permanent)
      ] ++ children(@target)

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Starts a worker by calling: LedCubeRpi3.Worker.start_link(arg)
      # {LedCubeRpi3.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Starts a worker by calling: LedCubeRpi3.Worker.start_link(arg)
      # {LedCubeRpi3.Worker, arg},
    ]
  end
end
