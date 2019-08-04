defmodule LedCubeRpi3.Buttons do
  use GenServer
  alias Pigpiox.GPIO

  @moduledoc """
  This is where all the functions and animations are going to be defined, as well as the use of some buttons
  
  LedCubeRpi3.CubeSupervisor.start_link()

  GenServer.cast({:via, Registry, {:cube_registry, :cube_server}}, {:set_layer_leds, 1, [:aa, :bb, :cc, :dd, :ee, :ff]})
  GenServer.cast({:via, Registry, {:cube_registry, :cube_server}}, {:set_layer_leds, 1, [:aa]})
  GenServer.cast({:via, Registry, {:cube_registry, :cube_server}}, {:set_layer_leds, 2, [:bb]})
  GenServer.cast({:via, Registry, {:cube_registry, :cube_server}}, {:set_layer_leds, 3, [:cc]})
  GenServer.cast({:via, Registry, {:cube_registry, :cube_server}}, {:set_layer_leds, 4, [:dd]})
  GenServer.cast({:via, Registry, {:cube_registry, :cube_server}}, {:set_layer_leds, 5, [:ee]})
  GenServer.cast({:via, Registry, {:cube_registry, :cube_server}}, {:set_layer_leds, 6, [:ff]})


      state = %{
      layer1: [:aa],
      layer2: [:bb],
      layer3: [:cc],
      layer4: [:dd],
      layer5: [:ee],
      layer6: [:ff]
    }
  """

  @all_leds [
    :aa,
    :ab,
    :ac,
    :ad,
    :af,
    :ba,
    :bb,
    :bc,
    :bd,
    :be,
    :bf,
    :ca,
    :cb,
    :cc,
    :cd,
    :ce,
    :cf,
    :da,
    :db,
    :dc,
    :dd,
    :de,
    :df,
    :ea,
    :eb,
    :ec,
    :ed,
    :ef,
    :fa,
    :fb,
    :fc,
    :fd,
    :fe,
    :ff
  ]
  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args, name: :buttons_server)
  end

  def via_tuple(name), do: {:via, Registry, {:cube_registry, name}}

  def init(pid) do
    GPIO.watch(16)
    GPIO.watch(20)
    GPIO.watch(21)
    state = pid
    {:ok, state}
  end

  def handle_info({:gpio_leveL_change, gpio, _level}, state) do
    case gpio do
      16 ->
        for n <- 1..6 do
          GenServer.cast(via_tuple(:cube_server), {:set_layer_leds, n, [nil]})
        end

      20 ->
        :next

      21 ->
        :prev
    end

    {:noreply, state}
  end

  def fn1() do
    drop_led(Enum.random(@all_leds), 6)
    Process.sleep(Enum.random(500..1500))
    fn1()
  end

  def drop_led(led, layer) do
    list = get_layer_leds(layer)
    GenServer.cast(via_tuple(:cube_server), {:set_layer_leds, layer, list ++ [led]})
    GenServer.cast(via_tuple(:cube_server), {:set_layer_leds, layer + 1, list -- [led]})
    Process.sleep(1000)
    if layer in 2..6, do: drop_led(led, layer - 1)
  end

  def get_layer_leds(layer) do
    GenServer.cast(via_tuple(:cube_server), {:get_state, self()})

    list =
      receive do
        {:state, state} ->
          list =
            case layer do
              1 ->
                state.layer1

              2 ->
                state.layer2

              3 ->
                state.layer3

              4 ->
                state.layer4

              5 ->
                state.layer5

              6 ->
                state.layer6
            end

          list
      end

    list
  end
end
