class {
  'hanaexpress':
    store_username => $facts['store_username'],
    store_password => $facts['store_password']
}

hanaexpress::database {
  'testhana1':
    version => '2.00.030.00.20180403.2',
    password => 'TestHanaExpress1',
    systemdb_port => 39017,
    tenantdb_port => 39041
}