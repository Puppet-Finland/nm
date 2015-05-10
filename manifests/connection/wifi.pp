#
# == Define: nm::connection::wifi
#
# Configure a Wifi connection. Currently WPA-PSK is assumed, but this define can 
# easily be extended.
#
# == Parameters
#
# [*psk*]
#   The pre-shared key (PSK) for this wifi connection.
# [*ifname*]
#   Name of the wireless LAN interface. Defaults to $::nm::default_wifi_iface.
# [*ssid*]
#   The SSID of the Access Point to connect to. Defaults to $title.
#  
define nm::connection::wifi
(
    $psk,
    $ifname = undef,
    $ssid = $title
)
{

    include ::nm::params

    if $ifname {
        $wifi_iface = $ifname
    } else {
        $wifi_iface = $::nm::default_wifi_iface
    }

    # Puppet versions prior to 3.8 do not support aggregate (i.e. array or hash) 
    # facts. Therefore the $::nm_connections fact produces a string where 
    # connection identifiers are separated with commas. The string is 
    # (re)converted into an array here to determine if this connection already 
    # exists.
    $connections = split($::nm_connections, ',')
    $exists = member($connections, $ssid)

    # Add the connection if it does not exist already. Later on this should be 
    # converted into a real Puppet type.
    unless $exists {
        exec { "nmcli add connection ${title}":
            command   => "nmcli connection add type 802-11-wireless ifname ${wifi_iface} con-name '${title}' ssid '${ssid}' &&
                        nmcli connection modify '${title}' 802-11-wireless-security.key-mgmt wpa-psk &&
                        nmcli connection modify '${title}' 802-11-wireless-security.psk ${psk}",
            # We don't want WLAN password to leak via email if we're running Puppet 
            # from cron.
            logoutput => false,
            path      => ['/bin', '/usr/bin', '/sbin', '/usr/sbin' ],
            require   => Class['nm::install'],
        }
    }
}
