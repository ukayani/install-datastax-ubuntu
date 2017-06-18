#!/usr/bin/env bash

echo "Running install-datastax/bin/opscenter.sh"

cloud_type=$1

echo "Configuring OpsCenter with the settings:"
echo cloud_type \'$cloud_type\'

if [[ $cloud_type == "azure" ]]; then
  ./os/set_tcp_keepalive_time.sh
fi

./os/install_java.sh
./opscenter/install.sh $cloud_type

if [[ $cloud_type == "azure" ]]; then
  opscenter_broadcast_ip=`curl --retry 10 icanhazip.com`
  ./opscenter/configure_opscenterd_conf.sh $opscenter_broadcast_ip
fi

echo "Starting OpsCenter..."
./opscenter/start.sh

echo "Waiting for OpsCenter to start..."
sleep 30