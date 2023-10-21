#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "[!] Usage: ${0} path"
    exit
fi

echo "[*]Working...." | lolcat 

cd $1
cat <<EOF > pyproject.toml
[tool.poetry]
name = "$(basename "$(pwd)")"
version = "0.1.0"
description = ""
authors = ["Saikat K <you@example.com>"]
readme = "README.md"

[tool.poetry.dependencies]
python = "^3.9"
eth-ape = "^0.6.22"

[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"
EOF

poetry install
# initialise the project with the current dir name
echo -e "$(basename "$(pwd)")\n" | poetry run ape init

echo "name: $(basename "$(pwd)")" > ape-config.yaml && echo "plugins:" >> ape-config.yaml && echo "  - name: solidity" >> ape-config.yaml && echo "  - name: alchemy" >> ape-config.yaml && echo "  - name: foundry" >> ape-config.yaml && echo "  - name: infura" >> ape-config.yaml && echo "  - name: etherscan" >> ape-config.yaml && echo "ethereum:" >> ape-config.yaml && echo "  default_network: mainnet-fork" >> ape-config.yaml && echo "  mainnet_fork:" >> ape-config.yaml && echo "    default_provider: foundry" >> ape-config.yaml && echo "    gas_limit: auto" >> ape-config.yaml && echo "    transaction_acceptance_timeout: 180" >> ape-config.yaml && echo "    default_transaction_type: 0" >> ape-config.yaml && echo "  mainnet:" >> ape-config.yaml && echo "    default_provider: alchemy" >> ape-config.yaml && echo "    transaction_acceptance_timeout: 180" >> ape-config.yaml && echo "foundry:" >> ape-config.yaml && echo "  fork:" >> ape-config.yaml && echo "    ethereum:" >> ape-config.yaml && echo "      mainnet_fork:" >> ape-config.yaml && echo "        upstream_provider: alchemy" >> ape-config.yaml && echo "test:" >> ape-config.yaml && echo "  mnemonic: test test test test test test test test test test test junk" >> ape-config.yaml && echo "  number_of_accounts: 10" >> ape-config.yaml

poetry run ape plugins install . --upgrade