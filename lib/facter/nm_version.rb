Facter.add('nm_version') do

    nmcli = '/usr/bin/nmcli'

    if File.file?(nmcli) then
        setcode do
            nm_version = Facter::Core::Execution.exec(nmcli << " --version 2>&1").split(' ').pop.split('-')[0]
        end
    end
end
