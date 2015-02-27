#
# == Define: nm::connection::wifi
#
# Configure a Wifi connection. Currently WPA-PSK is assumed, but this define can 
# easily be extended.
#
# == Parameters
#
# [*ifname*]
#   Name of the wireless LAN interface. Defaults to 'wlan0'.
# [*ssid*]
#   The SSID of the Access Point to connect to. Defaults to $title.
# [*psk*]
#  
define nm::connection::wifi
(
    $ifname = 'wlan0',
    $ssid = $title,
    $psk
)
{
    # Add the connection. This is brutal but works. Later on this should be 
    # converted into a real Puppet type. Alternatively the entire connection 
    # file should be made a template and filled in by Puppet.
    exec { "nmcli add connection $title":
        command => "nmcli connection add type 802-11-wireless ifname ${ifname} con-name '$title' ssid '$ssid' &&
                    nmcli connection modify '$title' 802-11-wireless-security.key-mgmt wpa-psk &&
                    nmcli connection modify '$title' 802-11-wireless-security.psk ${psk}",
        # We don't want WLAN password to leak via email if we're running Puppet 
        # from cron.
        logoutput => false,
        path => ['/bin', '/usr/bin', '/sbin', '/usr/sbin' ],
        creates => "/etc/NetworkManager/system-connections/$title",
        require => Class['nm::install'],
    }
}
