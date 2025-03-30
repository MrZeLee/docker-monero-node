#! /bin/sh

chown -R root:root /var/lib/tor/
chmod 700 -R /var/lib/tor/monerod

cp -f /torrc /etc/tor/torrc

if [ -n "$TOR_RESTRICTED_PORT" ] || [ -n "$TOR_ANONYMOUS_INBOUND_PORT" ]; then
  echo "HiddenServiceDir /var/lib/tor/monerod" >> /etc/tor/torrc

  if [ -n "$TOR_ANONYMOUS_INBOUND_PORT" ]; then
    echo "HiddenServicePort ${TOR_ANONYMOUS_INBOUND_PORT} monerod:${TOR_ANONYMOUS_INBOUND_PORT}" >> /etc/tor/torrc
  fi

  if [ -n "$TOR_RESTRICTED_PORT" ]; then
    echo "HiddenServicePort ${TOR_RESTRICTED_PORT} monerod:${RESTRICTED_PORT}" >> /etc/tor/torrc
  fi
fi

tor & pid=$!

if [ -n "$TOR_RESTRICTED_PORT" ] || [ -n "$TOR_ANONYMOUS_INBOUND_PORT" ]; then
  # Wait for onion address to be generated
  while [ ! -f /var/lib/tor/monerod/hostname ]; do
    sleep 1
  done

  echo "=========================================="
  echo "Your Monero RPC Onion address is: $(cat /var/lib/tor/monerod/hostname)"
  echo "=========================================="
fi

ps -p $pid && wait $pid
