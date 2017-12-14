# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Use bootloader to start the main application. See the bootloader
# docs for separating out critical OTP applications such as those
# involved with firmware updates.
config :bootloader,
  init: [:nerves_runtime, :nerves_network],
  app: Mix.Project.config[:app]

config :logger, level: :debug

config Mix.Project.config[:app], input_pin: System.get_env("INPUT_PIN") |> String.to_integer || 20
config Mix.Project.config[:app], output_pin: System.get_env("OUTPUT_PIN") |> String.to_integer || 26

#config :hello_network, interface: :eth0
config :hello_network, interface: :wlan0
#config :hello_network, interface: :usb0

# Customize the firmware. Uncomment all or parts of the following
# to add files to the root filesystem or modify the firmware
# archive.
config :nerves, :firmware,
  rootfs_overlay: "rootfs_overlay"
# fwup_conf: "config/fwup.conf"

key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

config :nerves_network, :default,
  wlan0: [
    ssid: System.get_env("NERVES_NETWORK_SSID"),
    psk: System.get_env("NERVES_NETWORK_PSK"),
    key_mgmt: String.to_atom(key_mgmt)
  ],
  eth0: [
    ipv4_address_method: :dhcp
  ]
