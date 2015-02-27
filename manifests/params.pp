#
# == Class: nm::params
#
# Defines some variables based on the operating system
#
class nm::params {

    case $::osfamily {
        'Debian': {
            $package_name = 'network-manager'
        }
        default: {
            fail("Unsupported OS: ${::osfamily}")
        }
    }
}
