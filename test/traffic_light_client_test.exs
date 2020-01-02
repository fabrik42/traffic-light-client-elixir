defmodule TrafficLightClientTest do
  use ExUnit.Case
  doctest TrafficLightClient

  test "greets the world" do
    assert TrafficLightClient.hello() == :world
  end
end
