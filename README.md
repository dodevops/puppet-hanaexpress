# SAP HANA Express docker hosting module

[![Build Status](https://travis-ci.org/dodevops/puppet-hanaexpress.svg?branch=master)](https://travis-ci.org/dodevops/puppet-hanaexpress)

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

## Integration tests

Because HANA express requires a lot of resources, the integration tests can not be run locally or automatically. We have, however, set up a kitchen integration test, that runs on Azure. Check out the [configuration docs](https://github.com/test-kitchen/kitchen-azurerm#configuration) if you want to start it. Additionally, you need a Docker store login and then run the tests like this:

    AZURE_SUBSCRIPTION_ID=your-azure-subscription-id AZURE_LOCATION=azure-location STORE_USERNAME=Docker-store-username STORE_PASSWORD=Docker-store-password bundle exec kitchen test all
