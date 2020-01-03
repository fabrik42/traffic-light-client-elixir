defmodule TrafficLightClient.LightSettingTest do
  use ExUnit.Case
  doctest TrafficLightClient.LightSetting

  alias TrafficLightClient.LightSetting

  test "is a struct" do
    light_setting = %LightSetting{mode: "ci", red: true, yellow: false, green: false}
    assert light_setting.mode == "ci"
    assert light_setting.red == true
    assert light_setting.yellow == false
    assert light_setting.green == false
  end

  test "light_diff with different settings (from nil to green)" do
    old_setting = %LightSetting{mode: nil, red: nil, yellow: nil, green: nil}
    new_setting = %LightSetting{mode: "public", red: false, yellow: false, green: true}

    diff = LightSetting.light_diff(old_setting, new_setting)

    assert diff == [{:green, true}, {:yellow, false}, {:red, false}]
  end

  test "light_diff with different settings (from red to yellow)" do
    old_setting = %LightSetting{mode: "ci", red: true, yellow: false, green: false}
    new_setting = %LightSetting{mode: "public", red: false, yellow: true, green: false}

    diff = LightSetting.light_diff(old_setting, new_setting)

    assert diff == [{:yellow, true}, {:red, false}]
  end

  test "light_diff with same settings" do
    old_setting = %LightSetting{mode: "ci", red: true, yellow: false, green: false}
    new_setting = %LightSetting{mode: "ci", red: true, yellow: false, green: false}

    diff = LightSetting.light_diff(old_setting, new_setting)

    assert diff == []
  end
end
