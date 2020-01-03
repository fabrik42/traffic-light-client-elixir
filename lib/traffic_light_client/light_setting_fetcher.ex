defmodule TrafficLightClient.LightSettingFetcher do
  alias TrafficLightClient.LightSetting

  @url "http://traffic-light-server.herokuapp.com/lights"

  def load do
    case HTTPoison.get(@url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        light_setting = Poison.decode!(body, as: %LightSetting{}, keys: :atoms!)
        {:ok, light_setting}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Unexpected status code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
