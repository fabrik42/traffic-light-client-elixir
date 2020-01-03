defmodule TrafficLightClient.Updater do
  use GenServer

  require Logger

  alias TrafficLightClient.LedOutput
  alias TrafficLightClient.LightSetting
  alias TrafficLightClient.LightSettingFetcher

  @update_interval 5 * 1000

  # Client

  def start_link(_ \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: UpdaterLink)
  end

  def update do
    GenServer.call(UpdaterLink, :update)
  end

  # Use these commands to introspect the gen server
  # :sys.get_status(UpdaterLink)
  # :sys.statistics(UpdaterLink, :get)
  # :sys.get_state(UpdaterLink)
  def enable_debug() do
    :sys.statistics(UpdaterLink, true)
    :sys.trace(UpdaterLink, true)
  end

  def disable_debug() do
    :sys.no_debug(UpdaterLink)
  end

  # Callbacks

  @impl true
  def init(default_state) do
    light_setting = %LightSetting{mode: "init"}

    leds = %{
      red: LedOutput.new(13),
      yellow: LedOutput.new(19),
      green: LedOutput.new(26)
    }

    state =
      default_state
      |> Map.put(:light_setting, light_setting)
      |> Map.put(:leds, leds)

    schedule_update()

    {:ok, state}
  end

  @impl true
  def handle_call(:update, _from, state) do
    new_state = update_from_server(state)
    {:reply, new_state, new_state}
  end

  @impl true
  def handle_info(:auto_update, state) do
    new_state = update_from_server(state)
    schedule_update()
    {:noreply, new_state}
  end

  defp schedule_update do
    Process.send_after(self(), :auto_update, @update_interval)
  end

  defp update_from_server(state) do
    %{leds: leds, light_setting: curr_light_setting} = state

    case LightSettingFetcher.load() do
      {:ok, new_light_setting} ->
        changes = LightSetting.light_diff(curr_light_setting, new_light_setting)
        apply_light_changes(leds, changes)
        log_changes(changes)
        %{state | light_setting: new_light_setting}

      {:error, reason} ->
        Logger.error("Could not fetch light settings from server: #{reason}")
        state
    end
  end

  defp apply_light_changes(leds, changes) do
    Enum.each(changes, fn {color, state} ->
      led = leds[color]
      LedOutput.update(led, state)
    end)
  end

  defp log_changes([]), do: nil

  defp log_changes(changes) do
    formatted = changes |> Enum.map(fn {c, s} -> "#{c}: #{s}" end) |> Enum.join(", ")

    Logger.info("Updated the lights successfully: #{formatted}")
  end
end
