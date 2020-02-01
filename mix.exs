defmodule LedCubeRpi3.MixProject do
  use Mix.Project

  @app :led_cube_rpi3
  @version "0.1.0"
  # @all_targets [:rpi, :rpi0, :rpi2, :rpi3, :rpi3a, :rpi4, :bbb, :x86_64]
  @target System.get_env("MIX_TARGET") || "host"
  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.9",
      archives: [nerves_bootstrap: "~> 1.6"],
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {LedCubeRpi3.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.5.0", runtime: false},
      {:shoehorn, "~> 0.6"},
      {:ring_logger, "~> 0.6"},
      {:toolshed, "~> 0.2"},
      {:distillery, "~> 2.1"}
    ] ++ deps(@target)
  end

  defp deps(target) do
    [
      {:nerves_runtime, "~> 0.6"},
      {:nerves_init_gadget, "~> 0.4"},
      {:pigpiox, path: "../pigpiox"},
      {:nerves_grove, path: "../nerves_grove"},
      {:circuits_gpio, "~> 0.1"}
      # {:circuits_i2c, "~> 0.1"}
    ] ++ system(target)
  end

  defp system("rpi"), do: [{:nerves_system_rpi, "~> 1.8", runtime: false}]
  defp system("rpi0"), do: [{:nerves_system_rpi0, "~> 1.8", runtime: false}]
  defp system("rpi2"), do: [{:nerves_system_rpi2, "~> 1.8", runtime: false}]
  defp system("rpi3"), do: [{:nerves_system_rpi3, "~> 1.8", runtime: false}]
  defp system("bbb"), do: [{:nerves_system_bbb, "~> 2.3", runtime: false}]
  defp system("x86_64"), do: [{:nerves_system_x86_64, "~> 1.8", runtime: false}]

  def release do
    [
      overwrite: true,
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod
    ]
  end
end
