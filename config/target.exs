use Mix.Config

# Authorize the device to receive firmware using your public key.
# See https://hexdocs.pm/nerves_firmware_ssh/readme.html for more information
# on configuring nerves_firmware_ssh.

keys =
  [
    Path.join([System.user_home!(), ".skm/taorg-rbrr-dev/id_rsa.pub"]),
    Path.join([System.user_home!(), ".skm/Mlopezc-rrbp3/id_rsa.pub"]),
    Path.join([System.user_home!(), ".skm/johannrbpi/id_rsa.pub"])
  ]
  |> Enum.filter(&File.exists?/1)

if keys == [],
  do:
    Mix.raise("""
    No SSH public keys found in ~/.ssh. An ssh authorized key is needed to
    log into the Nerves device and update firmware on it using ssh.
    See your project's config.exs for this error message.
    """)

config :nerves_firmware_ssh,
  authorized_keys: Enum.map(keys, &File.read!/1)

# Configure nerves_init_gadget.
# See https://hexdocs.pm/nerves_init_gadget/readme.html for more information.

# Setting the node_name will enable Erlang Distribution.
# Only enable this for prod if you understand the risks.
node_name = if Mix.env() != :prod, do: "led_cube_rpi3"

config :nerves_init_gadget,
  ifname: "wlan0",
  address_method: :dhcpd,
  mdns_domain: "nerves.local",
  node_name: node_name,
  node_host: :mdns_domain

  config :nerves_network,
  regulatory_domain: "ES"

  key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

  
config :nerves_network, :default,
  wlan0: [
    ipv4_address_method: :dhcp,
    ssid: System.get_env("NERVES_NETWORK_SSID"),
    psk: System.get_env("NERVES_NETWORK_PSK"),
    key_mgmt: String.to_atom(key_mgmt)
  ],
  eth0: [
    ipv4_address_method: :dhcp
  ]

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.target()}.exs"
