class global {

    $users_auth = 'ldap'
    $users_ldap_servers = ['ldap.geeksoc.org']
    $users_ldap_basedn = 'dc=geeksoc,dc=org'
    $users_ldap_ssl = 'yes'
    $syslog_server = 'picon.geeksoc.org'

    include users
    include sudo
    include ssh::sshd
    include ssh::known_hosts
    include munin::node
    include rsyslog
    include fail2ban
    include resolv
    include puppet

    resolv_conf { "geeksoc.org":
        domainname  => "geeksoc.org",
        searchpath  => ['geeksoc.org'],
        nameservers => ['130.159.248.50', '130.159.228.50'],
    }

    class { "ntp":
        servers       => [ 'ntp0.net.strath.ac.uk',
                           'ntp1.net.strath.ac.uk',
                           'ntp2.net.strath.ac.uk',
                           'ntp3.net.strath.ac.uk', ],
        autoupdate    => false,
    }


    # Global Packages
    case $::operatingsystem {
        debian, ubuntu: {
            $vim_name = "vim"
            $netcat_name = "netcat"
        }
        centos, redhat: {
            $vim_name = "vim-enhanced"
            $netcat_name = "nc"
        }
    }
    package { [ "screen",
                "tmux",
                "git",
                "bash-completion",
                "htop",
                "nmap",
                "mutt".
                "${netcat_name}",
                "${vim_name}", ]:
        ensure => installed,
    }

}
