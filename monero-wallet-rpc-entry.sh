#!/bin/sh

#set -e

wallet_path="${WALLET_VOLUME}/${WALLET_NAME}"

if [[ ! -r "${wallet_path}_viewonly" ]]; then
  if [[ ! -r "${wallet_path}" ]]; then
    monero-wallet-cli \
      --offline \
      --daemon-address ${DAEMON_ADDRESS} \
      --generate-new-wallet ${wallet_path} \
      --password ${WALLET_PASSWORD} \
      --mnemonic-language English \
      --use-english-language-names \
      --log-file /dev/null <<END
	exit
END
  fi
  if [[ ! -r "${wallet_path}.addr" ]]; then
    monero-wallet-cli \
      --offline \
      --daemon-address ${DAEMON_ADDRESS} \
      --wallet-file ${wallet_path} \
      --password ${WALLET_PASSWORD} \
      address | grep 'Primary' | cut -d ' ' -f3 >${wallet_path}.addr
  fi
  if [[ ! -r "${wallet_path}_viewkey.secret" ]]; then
    echo "${WALLET_PASSWORD}" | monero-wallet-cli \
      --offline \
      --daemon-address ${DAEMON_ADDRESS} \
      --wallet-file ${wallet_path} \
      --password ${WALLET_PASSWORD} \
      viewkey | grep 'secret' | cut -d ' ' -f2 >${wallet_path}_viewkey.secret
  fi
  monero-wallet-cli \
    --offline \
    --daemon-address ${DAEMON_ADDRESS} \
    --generate-from-view-key ${wallet_path}_viewonly \
    --password ${WALLET_PASSWORD} \
    --log-file /dev/null <<END
$(cat ${wallet_path}.addr)
$(cat ${wallet_path}_viewkey.secret)
END
fi

until monero-wallet-rpc \
  --confirm-external-bind \
  --rpc-bind-ip ${RPC_BIND_IP} \
  --rpc-bind-port ${RPC_BIND_PORT} \
  --daemon-address ${DAEMON_ADDRESS} \
  --wallet-file ${wallet_path}_viewonly \
  --password ${WALLET_PASSWORD} \
  --disable-rpc-login \
  --log-file /dev/null; do
  sleep 1
done
