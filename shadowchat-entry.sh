#!/bin/sh

set -e

if [[ ! -r ${SHADOWCHAT_ROOT}/config.json ]]; then
  echo "{
	\"MinimumDonation\":${MINIMUM_DONATION:-0.005},
	\"MaxMessageChars\":${MAX_MESSAGE_CHARS:-300},
	\"MaxNameChars\":${MAX_NAME_CHARS:-25},
	\"RPCWalletURL\":\"${RPC_WALLET_URL:-http://rpc:${RPC_BIND_PORT}/json_rpc}\",
	\"WebViewUsername\":\"${WEB_VIEW_USERNAME:-admin}\",
	\"WebViewPassword\":\"${WEB_VIEW_PASSWORD:-adminadmin}\",
	\"OBSWidgetRefresh\":\"${OBS_WIDGET_REFRESH:-10}\",
	\"ShowAmountCheckedByDefault\":${SHOW_AMOUNT_CHECKED_BY_DEFAULT:-true},
	\"EnableEmail\":${ENABLE_EMAIL:-false},
	\"SMTPServer\":\"${SMTP_SERVER:-smtp.purelymail.com}\",
	\"SMTPPort\":\"${SMTP_PORT:-587}\",
	\"SMTPUser\":\"${SMTP_USER:-example@purelymail.com}\",
	\"SMTPPass\":\"${SMTP_PASS:-12345678}\",
	\"SendToEmail\":[\"${SEND_TO_EMAIL:-example@purelymail.com}\"]
} " >${SHADOWCHAT_ROOT}/config.json
fi

cd ${SHADOWCHAT_ROOT}

until go run main.go; do
  sleep 1
done
