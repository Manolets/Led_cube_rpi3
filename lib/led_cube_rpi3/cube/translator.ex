defmodule LedCubeRpi3.Translator do
  require Logger

  @moduledoc """
  This module translates the atom key of each led to the actual address of the led on a layer
  To test:

  RingLogger.attach
  LedCubeRpi3.CubeSupervisor.start_link()
  leds = [:aa, :ab, :ac, :ad, :ae, :af, :ba, :bb, :bc, :bd, :be, :bf, :ca, :cb, :cc, :cd, :ce, :cf, :da, :db, :dc, :dd, :de, :df, :ea, :eb, :ec, :ed, :ee, :ef, :fa, :fb, :fc, :fd, :fe, :ff]
  LedCubeRpi3.Translator.leds_on(leds)

  for led <- leds do
  LedCubeRpi3.Translator.led(led, 0)
  Process.sleep(150)
  end
  """

  @chip0x20 [:aa, :ab, :ac, :ad, :ae, :af, :ba, :bb, :bc, :bd, :be, :bf, :ca, :cb, :cc, :cd]
  @chip0x21 [:ce, :cf, :da, :db, :dc, :dd, :de, :df, :ea, :eb, :ec, :ed, :ee, :ef, :fa, :fb]
  @gpios [:fc, :fd, :fe, :ff]

  def via_tuple(name), do: {:via, Registry, {:cube_registry, name}}

  def leds_on(list) do
    for led <- list, do: led(led, 1)
  end

  def led(id, value) do
    if id in @chip0x20 do
      chip = @chip0x20
      Logger.debug("Told to go to 0x20, #{inspect(via_tuple(:cube_server))} ")
      GenServer.cast(via_tuple(:cube_server), {:output_grove, index(id, chip), value})
    end

    if id in @chip0x21 do
      chip = @chip0x21
      Logger.debug("Told to go to 0x21, #{inspect(via_tuple(:cube_server))} ")
      GenServer.cast(via_tuple(:cube_server), {:output, index(id, chip), value})
    end

    if id in @gpios do
      Logger.debug("Told to go to gpio #{inspect(id)} ")

      case id do
        :fc ->
          Pigpiox.GPIO.write(5, value)

        :fd ->
          Pigpiox.GPIO.write(6, value)

        :fe ->
          Pigpiox.GPIO.write(13, value)

        :ff ->
          Pigpiox.GPIO.write(19, value)
      end
    end
  end

  def index(id, chip), do: Enum.find_index(chip, fn x -> x == id end)

  def all_leds_off() do
    for led <- @chip0x20 ++ @chip0x21 ++ @gpios, do: led(led, 0)
  end
end
