class openbsd-smtpd::base {
  include openbsd-smtpd::setup

  file{'/etc/mail/smtpd.conf':
    source => [ "puppet://$server/modules/site-openbsd-smtpd/config/${fqdn}/smtpd.conf",
                "puppet://$server/modules/site-openbsd-smtpd/config/${smtpd_type}/smtpd.conf",
                "puppet://$server/modules/site-openbsd-smtpd/config/smtpd.conf",
                "puppet://$server/modules/openbsd-smtpd/config/smtpd.conf" ],
    notify => Exec['check_smtpd_config'],
  }

  exec{'check_smtpd_config':
    command => 'smtpd -n',
    refreshonly => true,
    notify => Service['smtpd'],
  }

  service{'smtpd':
    start => '/usr/sbin/smtpd',
    hasstatus => false,
    hasrestart => false,
  }
}
