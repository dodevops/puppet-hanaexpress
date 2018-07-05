# SAP HANA Express docker hosting module

This module manages multiple SAP HANA Express instances using Docker as described on the [official SAP HANA Tutorials page](https://www.sap.com/developer/tutorials/hxe-ua-install-using-docker.html).

Please note, that this module **is in no means connected to SAP in any kind**. Please don't ask them for support.

# Usage

## Puppet

Initialize the hanaexpress class with your login credentials for the Docker store:

```
class {
    'hanaexpress':
        store_username => 'my_user',
        store_password => 'my_password'
}
```

After that, initialize docker instances using the database type:

```
hanaexpress::database {
    'testhana1':
        version => '2.00.030.00.20180403.2',
        password => 'TestHanaExpress1',
        systemdb_port => 39017,
        tenantdb_port => 39041
}
```

This will configure and startup a HANA express which will be available by ports 39017 for the systemdb and 39041 for the tenantdb. The SYSTEM user will have the given password.

## Hiera

This module directly supports hiera like this:

```
classes:
  - hanaexpress

hanaexpress::store_username: my_user
hanaexpress::store_password: my_password

hanaexpress-databases:
    testhana1:
        version: "2.00.030.00.20180403.2"
        password: 'TestHanaExpress1'
        systemdb_port: 39017
        tenantdb_port: 39041
```

# API

For details about the API see the [generated API documentation](https://dodevops.github.io/puppet-hanaexpress/).