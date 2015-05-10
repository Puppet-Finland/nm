Facter.add(:nm_connections) do

    confine :osfamily => [ 'RedHat', 'Debian' ]

    setcode do
        osfamily = Facter.value(:osfamily)

        case osfamily
        when 'RedHat'
            system_connection_dir = '/etc/sysconfig/network-scripts'
            file_pattern = 'ifcfg-*'
            line_pattern = '^NAME=.*$'
        when 'Debian'
            system_connection_dir = '/etc/NetworkManager/system-connections'
            file_pattern = '*'
            line_pattern = '^id=.*$'
        end

        connections = Array.new

        # Iterate over connection files in the system-connections directory. On 
        # RedHat-based systems the directory also contains files for connections 
        # created outside NetworkManager: this does not cause any side-effects 
        # when the $::nm_connections fact is only used to determine if a new 
        # connections should be added.
        #
        Dir.chdir(system_connection_dir)
        Dir.foreach(".") { |entry|
            if File.file?(entry) and File.fnmatch?(file_pattern, entry)
                File.open(entry).each { |line|
                    if line.match(line_pattern)
                        # On RedHat-based systems connection NAME might contain 
                        # double quotes, which have to be removed.
                        connection_id=line.split("=")[1].tr('"', '').chomp($/)
                        connections.push(connection_id)
                    end
                }
            end
        }
        # Until Puppet's stringify_facts becomes mainstream we need to convert 
        # the generated array into a string which we can easily parse and 
        # reconvert into an array in Puppet code.
        connections.join(",")
    end
end

