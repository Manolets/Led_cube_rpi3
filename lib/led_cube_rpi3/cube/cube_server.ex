defmodule LedCubeRpi3.Server do
  use GenServer
  alias Nerves.Grove.MCP23017.Fns, as: GroveFns
  alias Nerves.Grove.MCP23017.Supervisor, as: GroveSupervisor
  alias LedCubeRpi3.MCP23017.{Fns, Supervisor}
  alias LedCubeRpi3.{Translator, Caracteres}
  alias Pigpiox.GPIO
  require Logger

  @layer_gpios [7, 8, 9, 11, 17, 27]
  @moduledoc """

  RingLogger.attach
  LedCubeRpi3.CubeSupervisor.start_link()

  @all_leds [:aa, :ab, :ac, :ad, :ae, :af, :ba, :bb, :bc, :bd, :be, :bf, :ca, :cb, :cc, :cd, :ce, 
  :cf, :da, :db, :dc, :dd, :de, :df, :ea, :eb, :ec, :ed, :ee, :ef, :fa, :fb, :fc, :fd, :fe, :ff]
  """

  def init(_arg) do
    Logger.debug("Starting Led Cube Server")
    GroveSupervisor.start_link(0x20)
    Supervisor.start_link(0x21)

    for n <- 0..15 do
      GroveFns.set_mode(n, :output)
    end

    for n <- 0..15 do
      Fns.set_mode(n, :output)
    end

    for gpio <- @layer_gpios do
      GPIO.set_mode(gpio, :output)
      GPIO.write(gpio, 1)
    end

    state = %{
      layer1: [],
      layer2: [],
      layer3: [],
      layer4: [],
      layer5: [],
      layer6: [],
      layer_delay: 500
    }

    LedCubeRpi3.Buttons.start_link(self())
    Process.send(self(), {:layer_rotation, 1}, [:nosuspend])

    {:ok, state}
  end

  def handle_cast({:output_grove, pin, value}, state) do
    Logger.debug("Telling grove to set pin #{inspect(pin)} to value #{inspect(value)} ")
    GroveFns.output(pin, value)
    {:noreply, state}
  end

  def handle_cast({:output, pin, value}, state) do
    Logger.debug("Telling Ledcube to set pin #{inspect(pin)} to value #{inspect(value)} ")
    Fns.output(pin, value)
    {:noreply, state}
  end

  def handle_cast({:set_layer_leds, layer, list}, state) do
    state =
      case layer do
        1 ->
          Map.put(state, :layer1, list)

        2 ->
          Map.put(state, :layer2, list)

        3 ->
          Map.put(state, :layer3, list)

        4 ->
          Map.put(state, :layer4, list)

        5 ->
          Map.put(state, :layer5, list)

        6 ->
          Map.put(state, :layer6, list)

        _ ->
          nil
      end

    Logger.debug("This leds: #{inspect(list)}, in layer #{inspect(layer)}")

    {:noreply, state}
  end

  def handle_cast({:get_state, pid}, state) do
    Process.send(pid, {:state, state}, [:nosuspend])
    {:noreply, state}
  end

  def handle_info({:layer_rotation, pos}, state) do
    Translator.all_leds_off()

    for pin <- [7, 8, 9, 11, 17, 27] do
      GPIO.write(pin, 1)
    end

    case pos do
      1 ->
        Translator.leds_on(state.layer1)
        GPIO.write(7, 0)

      2 ->
        Translator.leds_on(state.layer2)
        GPIO.write(8, 0)

      3 ->
        Translator.leds_on(state.layer3)
        GPIO.write(11, 0)

      4 ->
        Translator.leds_on(state.layer4)
        GPIO.write(9, 0)

      5 ->
        Translator.leds_on(state.layer5)
        GPIO.write(27, 0)

      6 ->
        Translator.leds_on(state.layer6)
        GPIO.write(17, 0)
    end

    pos =
      if pos == 6 do
        pos = 0
        Process.send(self(), :last_layer_change, [:nosuspend])
        pos
      else
        pos
      end

    Process.sleep(state.layer_delay)
    Process.send(self(), {:layer_rotation, pos + 1}, [:nosuspend])

    {:noreply, state}
  end

  def handle_info({:button_pressed, button}, state) do
    case button do
      3 ->
        :ok

      _ ->
        :ok
    end

    {:noreply, state}
  end

  ##################################################################
  @doc """
  Definición de formas (de iluminación)
  """

  def handle_info({:palabra, word}, state) do
    word = String.codepoints(word)

    for c <- word do
      for layer <- 1..6 do
        GenServer.cast(self(), {:set_layer_leds, layer, Caracteres.select_case(c)})
      end

      receive do
        :last_layer_change ->
          :ok
      end
    end

    {:noreply, state}
  end
end
