class puppet {

	file { "/etc/puppet/puppet.conf":
	    content => template("puppet/puppet.conf.erb"),
	    mode    => 0600,
	    require => Package["puppet"],
	}


	# Run puppet agent every 30 mins via cron
    cron { "run-puppet":
        command => "/usr/bin/puppet agent --test > /dev/null",
        minute  => inline_template("<%= hostname.hash.abs % 30 %>"),
    }
    cron { "run-puppet2":
        command => "/usr/bin/puppet agent --test > /dev/null",
        minute  => inline_template("<%= hostname.hash.abs % 30 + 30 %>"),
    }
    service { "puppet":
        ensure => stopped,
        enable => false,
    }

}