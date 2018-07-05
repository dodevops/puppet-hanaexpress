# Sets up basic things needed for SAP HANA Express hosting based on
# [the SAP HANA Tutorial for Docker](https://www.sap.com/developer/tutorials/hxe-ua-install-using-docker.html).
#
# @summary Setup SAP HANA Express hosting
#
# @param store_username Username for the Docker store
# @param store_password Password for the Docker store
# @param hana_data_path Host path for persisting hana data
#
# @example
#   class {
#     "hanaexpress":
#         store_username => "my-docker-user",
#         store_password => "verysecret"
#   }
class hanaexpress (
  String $store_username,
  Optional[String] $store_password = undef,
  Optional[String] $store_pass_hash = undef,
  String $hana_data_path = "/data"
) {

  # Set Sysctl host settings (based on Step 5 of https://www.sap.com/developer/tutorials/hxe-ua-install-using-docker.html)

  sysctl {
    "fs.file-max":
      value => "20000000"
  }

  sysctl {
    "fs.aio-max-nr":
      value => "262144"
  }

  sysctl {
    "vm.memory_failure_early_kill":
      value => "1"
  }

  sysctl {
    "vm.max_map_count":
      value => "135217728"
  }

  sysctl {
    "net.ipv4.ip_local_port_range":
      value => "40000 60999"
  }

  # Login to the Docker store to pull SAP Hana images

  if ($store_password) {
    docker::registry {
      "https://index.docker.io/v1/":
        username => $store_username,
        password => $store_password
    }
  } else {
    docker::registry {
      "https://index.docker.io/v1/":
        username => $store_username,
        pass_hash => $store_pass_hash
    }
  }


  # Create the data persistence path

  file {
    $hana_data_path:
      ensure => "directory"
  }

  # Support Hiera

  $dbs = lookup({
    name => "hanaexpress-databases",
    merge => "hash",
    default_value => undef
  })

  if $dbs {
    create_resources("hanaexpress::database", $dbs)
  }

}
