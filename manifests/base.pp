class openbsd_smtpd::base {
  include openbsd_smtpd::setup

  file{'/etc/mail/smtpd.conf':
    source => [ "puppet:///modules/site_openbsd_smtpd/config/${::fqdn}/smtpd.conf",
                "puppet:///modules/site_openbsd_smtpd/config/${openbsd_smtpd::smtpd_type}/smtpd.conf",
                "puppet:///modules/site_openbsd_smtpd/config/smtpd.conf",
                "puppet:///modules/openbsd_smtpd/config/smtpd.conf" ],
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
