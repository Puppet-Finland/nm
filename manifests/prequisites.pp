# == Class: nm::prequisites
#
# Setup things required for the correct operation of the nm module. Note that 
# this does not help avoid warnings about versionomy missing on the first run, 
# because facts are loaded _before_ this manifest. On second run the warning is 
# gone, though.
#
class nm::prequisites inherits nm::params {

    # Ruby versionomy is needed by the $::nm_can_add_connection custom fact. 
    # That fact is used to determine if Network Manager supports adding 
    # connections or not.
    include ruby::versionomy
}
