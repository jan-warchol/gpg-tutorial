#!/bin/bash

source utils.sh

# This tutorial was tested with GPG 2.2.
# Check your version; you may have to use `gpg2` command to get GPG v2
run gpg --version | highlight "gpg.*[1-9]\.[0-9]\..*"

# create test identity
./setup-gpg-user.sh Alice
export GNUPGHOME=Alice

# Show key. E=encryption, S=signing, C=certification, A=authentication
# (see https://unix.stackexchange.com/a/230859)
run gpg --list-keys alice@example.com
run gpg --list-secret-keys alice@example.com | highlight "sec|ssb"
# (You can also use key ID/fingerprint instead of email.)

# To see key details, including trust value, use --edit-key dialog
run gpg --batch --edit-key alice@example.com quit

# For some reason private key files (stored in `private-keys-v1.d`)
# are named with "keygrips", not key IDs
run ls -l $GNUPGHOME/private-keys-v1.d/
run gpg --list-keys --with-keygrip alice@example.com

# Create an ASCII-encoded ("armored") encrypted message
echo "encryption test" > encryption-test
run gpg --armor --encrypt --recipient alice@example.com encryption-test
cat encryption-test.asc; echo

# Decrypt the message (gpg will prompt for key passphrase)
# Note that the key ID mentioned is the ID of *encryption subkey*, not main key
run gpg --decrypt encryption-test.asc |& highlight "[0-9A-F]{16,}"
run gpg --list-keys --with-subkey-fingerprint alice@example.com
