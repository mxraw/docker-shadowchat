# docker-shadowchat

This is a dockerized version of shadowchat, a

* Self-hosted, non-custodial and minimalist Monero (XMR) superchat system written in Go.
* Provides an admin view page to see donations with corresponding comments.
* Provides notification methods usable in OBS with an HTML page.

This docker container is actually two containers, one running the shadowchat app, the other the monero-wallet-rpc app, to improve security.

## Requirements

* docker
* docker-compose
* (optional) a text editor

## Installation

It's as simple as ```docker-compose up --build -d```.

This should be enough to get the service running on port 8900.

Please be aware that monero-wallet-rpc does *not* expose the RPC port until after it has finished syncing. This may take a while. Until then, the web interface will throw E500 when clicking pay.

You can customize the docker container by editing the .env file.

The container only needs to be build once, successive executions only require ```docker-compose up -d```.

### Note

If ${WALLET_NAME}_viewonly is not present in $WALLET_ROOT, the container will attempt to generate a new wallet and all other required files using ${WALLET_PASSWORD}. This may be too insecure for your needs, especially when running the docker container on a VPS.

You only need the ${WALLET_NAME}_viewonly and ${WALLET_NAME}_viewonly.keys files for shadowchat to function. You may want to backup all other files from ${WALLET_ROOT} to a local disk or supply your own keypair.
