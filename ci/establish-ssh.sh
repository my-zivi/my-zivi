#!/bin/bash -vue

SSH_FILE=$HOME/.ssh/id_rsa
openssl aes-256-cbc \
    -K $encrypted_947905863296_key \
    -iv $encrypted_947905863296_iv \
    -in ".id_rsa.enc" \
    -out "$SSH_FILE" -d
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Enable SSH authentication
chmod 600 "$SSH_FILE"
echo "stiftungswo.ch,149.126.4.24 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBN43sGVazZlEbitcxVESOns6JtFcXbrbu5/9AvBwacZNvhKofbiY2wn748QbrVAeAVRdfJ7W3/0t9sOLv/avvXs=" > $HOME/.ssh/known_hosts
