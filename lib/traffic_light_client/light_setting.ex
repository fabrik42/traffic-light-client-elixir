defmodule TrafficLightClient.LightSetting do
  defstruct mode: nil, red: nil, yellow: nil, green: nil

  def light_diff(old, new) do
    [:red, :yellow, :green]
    |> Enum.reduce([], fn color, acc ->
      if Map.get(old, color) == Map.get(new, color) do
        acc
      else
        [{color, Map.get(new, color)} | acc]
      end
    end)
  end
end
