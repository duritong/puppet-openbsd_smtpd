class openbsd_smtpd::setup {
  include sendmail::newaliases
  file{'/etc/mailer.conf':
    source => "puppet:///modules/openbsd_smtpd/config/mailer.conf",
    notify => [ Exec['refresh_aliases'], Exec['kill_sendmail'] ],
    owner => root, group => 0, mode => 0644;
  }

  exec{'kill_sendmail':
    command => 'pkill sendmail',
    refreshonly => true,
  }

  file_line{'disable_sendmail':
    path => '/etc/rc.conf.local',
    line => 'sendmail_flags=NO',
    before => Line['enable_smtpd'],
  }
  file_line{'enable_smtpd':
    path => '/etc/rc.conf.local',
    line => 'smtpd_flags=',
    notify => Service['smtpd'],
  }
}
