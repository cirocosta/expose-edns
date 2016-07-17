#!/bin/bash

set -ex

# Tests the exposure of the embedded DNS of a container that is
# connected to an user-defined network.
#
# Here we use two networks: the default `bridge` network and the
# `testnet` network.
#
# Three containers are ran:
#   - nginx (nginx)              -- connected to testnet only
#   - dns (cirocosta/expose-dns) -- connected to both bridge and testnet
#   - dig (cirocosta/alpine-dig) -- connected to only bridge
#
# 
#  [testnet]                                   [bridge]
#     +------nginx                    dig---------+
#     +-------------------dns---------------------+
#
#  We want to have `dig` discovering the IP of `nginx` on testnet.
# 
#  ps.: Obviously `dig` can't connect to that IP as it's not part of that
#  network.

main () {
  create_testnet

  create_container 'dns' 'cirocosta/expose-edns'
  create_container 'nginx' 'nginx:1.10.1-alpine'

  connect_to_testnet 'dns'
  connect_to_testnet 'nginx'
  disconnect_from_bridge 'nginx'

  use_dig_to_resolve_nginx_ip_on_testnet
}


create_testnet () {
  if ! docker network ls | grep testnet; then
    docker network create testnet
  fi
}

create_container () {
  local container_name=$1
  local container_image=$2

  docker run -d --name $container_name $container_image
}

connect_to_testnet () {
  local container_name=$1

  docker network connect 'testnet' $container_name
}

disconnect_from_bridge () {
  local container_name=$1

  docker network disconnect 'bridge' $container_name
}

use_dig_to_resolve_nginx_ip_on_testnet () {
  local dns_bridge_ip=`docker inspect --format '{{ .NetworkSettings.Networks.bridge.IPAddress }}' dns`

  docker run cirocosta/alpine-dig dig nginx "@$dns_bridge_ip"
}

main
