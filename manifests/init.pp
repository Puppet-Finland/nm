# == Class: nm
#
# This class install and configures Network Manager
#
# == Parameters
#
# [*manage*]
#   Whether to manage Network Manager using Puppet or not. Valid values 'yes' 
#   (default) and 'no'.
# [*warn*]
#   Warn if Network Manager is too old to support some features of this module, 
#   such as defining WIFI connections. While this feature is arguably useful, it 
#   will produce possibly unwanted output. Valid values are 'yes' (default) and 
#   'no'.
# [*wifi_connections*]
#   A hash of nm::connection::wifi resources to realize.
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
    $manage = 'yes',
    $warn = 'yes',
    $wifi_connections = {},

) inherits nm::params
{

if $manage == 'yes' {

    include nm::prequisites
    include nm::install

    if $::nm_can_add_connection == 'True' {
        create_resources('nm::connection::wifi', $wifi_connections)
    } else {
        if $warn == 'yes' {
            notify { "This version of nmcli (${::nm_version}) does not support adding connections. Please update your version of Network Manager.": }
        }
    }
}
}
