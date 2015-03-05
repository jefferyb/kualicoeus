# == Class: kualicoeus::oracle
#
# Class to manage Oracle Database
#
# === Authors
#
# Jeffery Bagirimvano <jeffery.rukundo@gmail.com>
#
# === Copyright
#
# Copyright 2014 Jeffery B.
#

class kualicoeus::oracle {
  if $kualicoeus::setup_database {
    # Setup Oracle XE 11g using Docker
    class { 'kualicoeus::config::sqlplus': } ->
    class { 'docker': } ->
    docker::image { $kualicoeus::oracle_docker_image: } ->
    docker::run { 'docker_oracle_xe':
      image           => $kualicoeus::oracle_docker_image,
      ports           => ['49160:22', '49161:1521', '49162:8080'],
      use_name        => true,
      restart_service => true,
    }
  }
}
