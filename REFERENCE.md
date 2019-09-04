# Reference
<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

**Classes**

* [`hanaexpress`](#hanaexpress): Setup SAP HANA Express hosting

**Defined types**

* [`hanaexpress::database`](#hanaexpressdatabase): Sets up a container with a SAP HANA database

## Classes

### hanaexpress

Sets up basic things needed for SAP HANA Express hosting based on
[the SAP HANA Tutorial for Docker](https://www.sap.com/developer/tutorials/hxe-ua-install-using-docker.html).

#### Parameters

The following parameters are available in the `hanaexpress` class.

##### `store_username`

Data type: `String`

Username for the Docker store

##### `store_password`

Data type: `String`

Password for the Docker store

##### `hana_data_path`

Data type: `String`

Host path for persisting hana data

##### `pass_is_hash`

Data type: `Boolean`

Set to true, if the password is actually the password hash of the user

##### `manage_service`

Data type: `Boolean`

Manage a system service for each managed app

## Defined types

### hanaexpress::database

Sets up a container with a SAP HANA database

#### Parameters

The following parameters are available in the `hanaexpress::database` defined type.

##### `name`

Name of the hana instance (only ASCII-characters and numbers are allowed)

##### `version`

Data type: `String`

Version of the HANA image to use (i.e. 2.00.030.00.20180403.2)

##### `password`

Data type: `String`

Master password. [Step 7](See https://www.sap.com/developer/tutorials/hxe-ua-install-using-docker.html) for
specifics about valid passwords

##### `systemdb_port`

Data type: `Integer`

Port to use for the HANA System database

##### `tenantdb_port`

Data type: `Integer`

Port to use for the HANA default tenant database (HXE)

##### `manage_service`

Data type: `Optional[Boolean]`

Manage a system service for this database

Default value: `undef`
