# == Class: nm
#
# This class install and configures Network Manager
#
# == Parameters
#
# [*manage*]
#   Whether to manage Network Manager using Puppet or not. Valid values true 
#   (default) and false.
# [*warn*]
#   Warn if Network Manager is too old to support some features of this module, 
#   such as defining WIFI connections. While this feature is arguably useful, it 
#   will produce possibly unwanted output. Valid values are true (default) and 
#   false.
# [*wifi_connections*]
#   A hash of nm::connection::wifi resources to realize.
# [*default_wifi_iface*]
#   Sets the default value for $ifname in ::nm::connection::wifi defined 
#   resource. Defaults to 'wlan0'.
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class nm
(
    Boolean $manage = true,
    Boolean $warn = true,
    Hash    $wifi_connections = {},
    String  $default_wifi_iface = 'wlan0'

) inherits nm::params
{

if $manage {

    include ::nm::install

    if versioncmp($::nm_version,'0.9.10.0') > 0 {
        create_resources('nm::connection::wifi', $wifi_connections)
    } else {
        if $warn {
            notify { "This version of nmcli (${::nm_version}) does not support adding connections. Please update your version of Network Manager.": }
        }
    }
}
}
