require 'serverspec'
set :backend, :exec
set :path, '/bin:/usr/bin:/sbin:/usr/sbin:$PATH'
