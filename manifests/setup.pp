class openbsd-smtpd::setup {
  include sendmail::newaliases
  file{'/etc/mailer.conf':
    source => "puppet://$server/modules/openbsd-smtpd/config/mailer.conf",
    notify => [ Exec['refresh_aliases'], Exec['kill_sendmail'] ],
    owner => root, group => 0, mode => 0644;
  }

  exec{'kill_sendmail':
    command => 'pkill sendmail',
    refreshonly => true,
  }

  line{'disable_sendmail':
    file => '/etc/rc.conf.local',
    line => 'smtpd_flags=',
  }
  line{'enable_smtpd':
    file => '/etc/rc.conf.local',
    line => 'smtpd_flags=',
    notify => Service['smtpd'],
  }
}
