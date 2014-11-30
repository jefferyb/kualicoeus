#
# Class to manage Oracle Database
#

class kualicoeus::oracle {
  # Setup Oracle XE 11g using Docker
  class { 'kualicoeus::config::sqlplus': } ->
  class { 'docker': } ->
  docker::image { 'alexeiled/docker-oracle-xe-11g': } ->
  docker::run { 'docker_oracle_xe':
    image           => 'alexeiled/docker-oracle-xe-11g',
    ports           => ['49160:22', '49161:1521', '49162:8080'],
    use_name        => true,
    restart_service => true,
  }
}
