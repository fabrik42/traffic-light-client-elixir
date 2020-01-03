defmodule TrafficLightClient.LightSetting do
  defstruct mode: nil, red: nil, yellow: nil, green: nil

  def light_diff(old, new) do
    [:red, :yellow, :green]
    |> Enum.reduce([], fn color, acc ->
      color_state = &Map.get(&1, color)

      if color_state.(old) == color_state.(new) do
        acc
      else
        [{color, color_state.(new)} | acc]
      end
    end)
  end
end
