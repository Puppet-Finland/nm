# nm

A Puppet module for managing Network manager. Supports configuring Wifi 
connections on recent Network Manager versions. This module adds two custom 
facts:

* $::nmcli_version: Version number of nmcli.
* $::nmcli_can_add_connection: "True" if nmcli supports adding connections, "False" otherwise.

# Module usage

* [Class: nm](manifests/init.pp)
* [Define: nm::connection::wifi](manifests/connection/wifi.pp)

# Dependencies

This module depends on ruby-versionomy, which is automatically installed only 
for Debian derivatives, where it can be trivially installed from the 
distribution's standard repositories. See [metadata.json](metadata.json) for 
details.

# Operating system support

This module has been tested on

* Debian 8 64-bit

It should work on any Linux that has relatively recent version of nmcli. For 
details see [params.pp](manifests/params.pp).
