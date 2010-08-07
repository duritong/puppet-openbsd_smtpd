class openbsd-smtpd::base {
  include openbsd-smtpd::setup

  file{'/etc/mail/smtpd.conf':
    source => [ "puppet:///modules/site-openbsd-smtpd/config/${fqdn}/smtpd.conf",
                "puppet:///modules/site-openbsd-smtpd/config/${smtpd_type}/smtpd.conf",
                "puppet:///modules/site-openbsd-smtpd/config/smtpd.conf",
                "puppet:///modules/openbsd-smtpd/config/smtpd.conf" ],
    notify => Exec['check_smtpd_config'],
    owner => root, group => 0, mode => 0644;
  }

  exec{'check_smtpd_config':
    command => 'smtpd -n',
    refreshonly => true,
    notify => Service['smtpd'],
  }

  service{'smtpd':
    ensure => running,
    provider => 'base',
    binary => '/usr/sbin/smtpd',
    status => 'smtpctl show stats'
  }
}
