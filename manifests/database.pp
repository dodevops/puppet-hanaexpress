# Sets up a container with a SAP HANA database
#
# @summary Sets up a container with a SAP HANA database
#
# @param name Name of the hana instance (only ASCII-characters and numbers are allowed)
# @param version Version of the HANA image to use (i.e. 2.00.030.00.20180403.2)
# @param password
#   Master password. [Step 7](See https://www.sap.com/developer/tutorials/hxe-ua-install-using-docker.html) for
#   specifics about valid passwords
# @param systemdb_port Port to use for the HANA System database
# @param tenantdb_port Port to use for the HANA default tenant database (HXE)
#
# @example
#   hanaexpress::database { 'namevar': }
define hanaexpress::database(
  String $version,
  String $password,
  Integer $systemdb_port,
  Integer $tenantdb_port
) {

  include hanaexpress

  $_name = pick($name, $title)

  # Create data path

  file {
    "${::hanaexpress::hana_data_path}/${_name}":
      ensure => "directory",
      owner => 12000,
      group => 79
  }

  # Create password file

  file {
    "${::hanaexpress::hana_data_path}/${_name}/password.json":
      ensure => "file",
      content => to_json({
        "master_password" => $password
      }),
      owner => 12000,
      group => 79,
      mode => "0600"
  } ->

  # Start container

  docker::run {
    "hana-${_name}":
      hostname => "hana-${_name}",
      image => "store/saplabs/hanaexpress:${version}",
      ports => [
        "${systemdb_port}:39017",
        "${tenantdb_port}:39041"
      ],
      volumes => [
        "${::hanaexpress::hana_data_path}/${_name}:/hana/mounts"
      ],
      extra_parameters => [
        "--ulimit nofile=1048576:1048576",
        "--sysctl kernel.shmmax=1073741824",
        "--sysctl net.ipv4.ip_local_port_range=\"40000 60999\"",
        "--sysctl kernel.shmmni=524288",
        "--sysctl kernel.shmall=8388608",
      ],
      command => "--passwords-url file:///hana/mounts/password.json --agree-to-sap-license"
  }

}
