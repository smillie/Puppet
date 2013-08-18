class pam-ldap (
    $servers = '',
    $basedn ='',
    $ssl = 'yes',
  ) {   

    file { "nsswitch.conf":
        path    => "/etc/nsswitch.conf",
        mode    => "644",
        owner   => "root",
        group   => "root",
        require => [ File["ldap.conf"] ],
        ensure  => present,
        content => template("pam-ldap/nsswitch.conf.erb"),
    }

    file { "ldap.conf":
        path    => $operatingsystem ? {
          debian => "/etc/libnss-ldap.conf",
          default => "/etc/ldap.conf",
        },
        mode    => "644",
        owner   => "root",
        group   => "root",
        ensure  => present,
        content => template("pam-ldap/ldap.conf.erb"),
    }

    file { "openldap-ldap.conf":
        path    => $operatingsystem ? {
            debian => "/etc/ldap/ldap.conf",
            ubuntu => "/etc/ldap/ldap.conf",
            /(?i:CentOS|RedHat|Scientific)/ => "/etc/openldap/ldap.conf",
        },
        mode    => "644",
        owner   => "root",
        group   => "root",
        ensure  => present,
        content => template("pam-ldap/openldap-ldap.conf.erb"),
    }

    case $users_ldap_ssl {
        yes: {
            file { "ldap_cacert":
                path    => $operatingsystem ? {
                  'debian' => "/etc/ldap/cacert.pem",
                  'ubuntu' => "/etc/ldap/cacert.pem",
                  default  => "/etc/openldap/cacert.pem",
                },
                mode    => "644",
                owner   => "root",
                group   => "root",
                ensure  => present,
                source => "puppet:///modules/pam-ldap/ldap.geeksoc.org.cert",
            }
        }
    }


    case $operatingsystem {
      Ubuntu,Debian: {
        package { "libpam-ldap": ensure => purged }
        package { "libnss-ldap": ensure => present }
        package { "ldap-utils": ensure => present }
        if $common::osver == 7 {package { "libpam-ldapd": ensure => present } }

        case $common::osver {
          5,6,7: {
            file { "pam_ldap.conf":
              path    => "/etc/pam_ldap.conf",
              mode    => "644",
              owner   => "root",
              group   => "root",
              ensure  => present,
              content => template("users/ldap/ldap.conf.erb"),
            }
          }
        }
      }
      redhat,centos: {
        if $common::osver != 6 { package { "nss_ldap": ensure => present } }
      }
    }

}
