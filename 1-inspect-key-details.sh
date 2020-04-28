#!/bin/bash

# Use `gpg --help` to list commands and `man gpg` for details.

# check version - does `gpg` command points to GPG v2?
# Otherwise you may have to use `gpg2` command.
echo -n "This script was tested with GPG 2.2.4. Your version: "
gpg --version | grep "gpg.*[1-9]\.[0-9]\."
echo

# helper to show nicely formatted command (use stderr to separate from actual output)
run() { echo -e "\e[1;37m>>> $@ \e[0m" >&2; eval "$@"; echo "" >&2; }

# setup test identity and get key id
./setup-gpg-user.sh key-test
read KEY_ID < key-test/key-id
export GNUPGHOME=key-test

# Show key. E=encryption, S=signing, C=certification, A=authentication
# (see https://unix.stackexchange.com/a/230859)
run gpg --list-keys $KEY_ID
run gpg --list-secret-keys $KEY_ID

# To see key details, including trust value, use --edit-key dialog
run gpg --batch --edit-key $KEY_ID quit

# For some reason private key files (stored in `private-keys-v1.d`)
# are named with "keygrips", not key IDs
run ls -l $GNUPGHOME/private-keys-v1.d/
run gpg --list-keys --with-keygrip $KEY_ID

# Create an ASCII-encoded encrypted message (key ID can be used for --recipient, too)
echo "encryption test" > $GNUPGHOME/test-message
run gpg --armor --encrypt --recipient key-test@example.com $GNUPGHOME/test-message
cat $GNUPGHOME/test-message.asc; echo

# Decrypt the message (gpg will prompt for key passphrase)
# Note that the key ID mentioned is the ID of *encryption subkey*, not main key
run gpg --decrypt $GNUPGHOME/test-message.asc
run gpg --list-keys --with-subkey-fingerprint $KEY_ID
