# == Class: nm::install
#
# This class installs Network Manager
#
class nm::install inherits nm::params {

    package { $::nm::params::package_name:
        ensure => installed,
        require => Class['nm::prequisites'],
    }
}
