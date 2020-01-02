defmodule TrafficLightClient.LedOutput do
  defstruct gpio: nil, pin: nil

  alias Circuits.GPIO

  def new(pin) do
    {:ok, output_gpio} = GPIO.open(pin, :output)

    %__MODULE__{pin: pin, gpio: output_gpio}
  end

  def update(output, false), do: GPIO.write(output.gpio, 0)
  def update(output, true), do: GPIO.write(output.gpio, 1)
end
