class zabbix_agent_haproxy (
  $agent_include  = '/etc/zabbix/zabbix_agentd.d/',
  $bin_path       = '/usr/local/bin',
  ) {

  file { 'userparameter_haproxy.conf':
    path   => "${agent_include}/userparameter_haproxy.conf",
    source => 'puppet:///modules/zabbix_agent_haproxy/userparameter_haproxy.conf',
  }

  file { 'haproxy_discovery.sh':
    path   => "${bin_path}/haproxy_discovery.sh",
    source => 'puppet:///modules/zabbix_agent_haproxy/haproxy_discovery.sh',
    mode   => '0775',
  }

  file { 'haproxy_stats.sh':
    path   => "${bin_path}/haproxy_stats.sh",
    source => 'puppet:///modules/zabbix_agent_haproxy/haproxy_stats.sh',
    mode   => '0775',
  }

  package { 'netcat-openbsd': ensure => 'present', }

  exec {'zabbix haproxy membership':
    unless  => "/bin/grep -q 'haproxy\\S*zabbix' /etc/group",
    command => '/sbin/usermod -aG haproxy zabbix',
    notify  => Service['zabbix-agent'],
  }
}
