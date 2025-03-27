#! /bin/sh

extra_args=""

if [ -n "$TOR_RESTRICTED_PORT" ] || [ -n "$TOR_ANONYMOUS_INBOUND_PORT" ]; then
  # Wait for onion address to be generated
  while [ ! -f /var/lib/tor/monerod/hostname ]; do
    sleep 1
  done

  echo "=========================================="
  echo "Your Monero RPC Onion address is: $(cat /var/lib/tor/monerod/hostname)"
  echo "=========================================="

  tor_hostname=$(cat /var/lib/tor/monerod/hostname)
  extra_args="--anonymous-inbound ${tor_hostname}:${TOR_ANONYMOUS_INBOUND_PORT},127.0.0.1:${TOR_ANONYMOUS_INBOUND_PORT},64 \
--disable-rpc-ban"
fi

/usr/local/bin/monerod \
  --data-dir=/data \
  --p2p-bind-ip=0.0.0.0 \
  --p2p-bind-port=18080 \
  --rpc-restricted-bind-ip=0.0.0.0 \
  --rpc-restricted-bind-port=18081 \
  --zmq-rpc-bind-ip=127.0.0.1 \
  --zmq-rpc-bind-port=18082 \
  --rpc-bind-ip=0.0.0.0 \
  --rpc-bind-port=18083 \
  --non-interactive \
  --confirm-external-bind \
  --public-node \
  --log-level=0 \
  --rpc-ssl=disabled \
  --proxy=172.31.255.250:9050 \
  --ban-list=/ban_list.txt \
  --tx-proxy=tor,172.31.255.250:9050,disable_noise,24 \
  --tx-proxy=i2p,172.31.255.251:4447,disable_noise,24 \
  $extra_args
