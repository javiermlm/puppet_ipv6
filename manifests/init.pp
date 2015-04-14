class ipv6 {
 if ($osfamily  == 'redhat') and ( versioncmp($operatingsystemrelease, '5') > 0 ) {
  case $::operatingsystemrelease {
   /^5/: {
       $modfile = '/etc/modprobe.conf'
     file_line { 'net_pf':
       ensure => present,
       path => $modfile,
       line => 'alias net-pf-10 off',
       match => '^alias net-pf-10',
       require => File[$modfile],
     }
   }
   /^6/,/^7/: {
       $modfile = '/etc/modprobe.d/ipv6.conf'
     file { '/etc/sysctl.conf':
       ensure => file,
       owner => root,
       group => root,
       mode => '0644',
     }
     file_line { 'ipv6.conf.all':
       ensure => present,
       path => '/etc/sysctl.conf',
       line => 'net.ipv6.conf.all.disable_ipv6 = 1',
       match => '^net.ipv6.conf.all.disable_ipv6',
       require => File['/etc/sysctl.conf'],
     }
     file_line { 'ipv6.conf.default':
       ensure => present,
       path => '/etc/sysctl.conf',
       line => 'net.ipv6.conf.default.disable_ipv6 = 1',
       match => '^net.ipv6.conf.default.disable_ipv6',
       require => File['/etc/sysctl.conf'],
     }
   }
   default: {
     fail ("version not supported")
   }
  }
  file { $modfile:
     ensure => present,
     owner => root,
     group => root,
     mode => '0644',
  }
  file_line { 'ipv6_dis':
     ensure => present,
     path => $modfile,
     line => 'options ipv6 disable=1',
     match => '^options ipv6',
     require => File[$modfile],
  }
  service { 'ip6tables':
     ensure => stopped,
     enable => false,
  }
  file { '/etc/sysconfig/network':
     ensure => present,
     owner => root,
     group => root,
     mode => '0644',
  }
  file_line { 'networking':
     ensure => present,
     path => '/etc/sysconfig/network',
     line => 'NETWORKING_IPV6=no',
     match => '^NETWORKING_IPV6',
     require => File['/etc/sysconfig/network'],
  }
 }
}
