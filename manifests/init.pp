# Sets up basic things needed for SAP HANA Express hosting based on
# [the SAP HANA Tutorial for Docker](https://www.sap.com/developer/tutorials/hxe-ua-install-using-docker.html).
#
# @summary Setup SAP HANA Express hosting
#
# @param store_username Username for the Docker store
# @param store_password Password for the Docker store
# @param hana_data_path Host path for persisting hana data
# @param pass_is_hash Set to true, if the password is actually the password hash of the user
# @param manage_service Manage a system service for each managed app
class hanaexpress (
  String $store_username,
  String $store_password,
  String $hana_data_path,
  Boolean $pass_is_hash,
  Boolean $manage_service,
) {

  # Set Sysctl host settings (based on Step 5 of https://www.sap.com/developer/tutorials/hxe-ua-install-using-docker.html)

  sysctl {
    'fs.file-max':
      value => '20000000'
  }

  sysctl {
    'fs.aio-max-nr':
      value => '262144'
  }

  sysctl {
    'vm.memory_failure_early_kill':
      value  => '1',
      silent => true,
  }

  sysctl {
    'vm.max_map_count':
      value => '135217728'
  }

  sysctl {
    'net.ipv4.ip_local_port_range':
      value => '40000 60999'
  }

  # Set up docker in general if not yet done (see https://github.com/puppetlabs/puppetlabs-docker/issues/461
  # and https://github.com/dodevops/puppet-hanaexpress/issues/1 for background)

  if !defined(Class['docker']) {
    include 'docker'
  }

  # Login to the Docker store to pull SAP Hana images

  if ($pass_is_hash) {
    docker::registry {
      'https://index.docker.io/v1/':
        username  => $store_username,
        pass_hash => $store_password
    }
  } else {
    docker::registry {
      'https://index.docker.io/v1/':
        username => $store_username,
        password => $store_password
    }
  }

  # Create the data persistence path

  file {
    $hana_data_path:
      ensure => 'directory'
  }

  # Support Hiera

  $_dbs = lookup({
    name          => 'hanaexpress-databases',
    merge         => 'hash',
    default_value => undef
  })

  if $_dbs {
    create_resources('hanaexpress::database', $_dbs)
  }

}
