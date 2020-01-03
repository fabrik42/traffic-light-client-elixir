defmodule TrafficLightClient.LightSettingFetcherTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  doctest TrafficLightClient.LightSettingFetcher

  alias TrafficLightClient.LightSetting
  alias TrafficLightClient.LightSettingFetcher

  setup_all do
    HTTPoison.start()
  end

  test "parses a valid response" do
    use_cassette "traffic_light_server_lights" do
      {:ok, setting} = LightSettingFetcher.load()

      assert setting == %LightSetting{
               mode: "ci",
               red: true,
               yellow: false,
               green: false
             }
    end
  end

  test "handles an invalid response" do
    use_cassette :stub, url: "~r/.+/", status_code: 500 do
      {:error, reason} = LightSettingFetcher.load()

      assert reason == "Unexpected status code: 500"
    end
  end
end
