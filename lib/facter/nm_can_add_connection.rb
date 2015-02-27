require 'versionomy'

Facter.add('nm_can_add_connection') do

    setcode do
        min_version = Versionomy.parse('0.9.10.0')
        current_version = Versionomy.parse(Facter.value(:nm_version))
        can_add = (min_version <= current_version)

        # Return value of a custom fact can't be a real boolean:
        #
        # <http://projects.puppetlabs.com/issues/3704>
        #
        # Here we explicitly return a string to emphasize that fact.
        #
        if can_add then
            "True"
        else
            "False"
        end
    end
end
