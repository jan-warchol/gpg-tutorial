#!/bin/bash

source utils.sh

# check version - does `gpg` command points to GPG v2?
# Otherwise you may have to use `gpg2` command.
echo "This script was tested with GPG 2.2.4." | highlight "2.2.4"
echo "Your version:"
run gpg --version | highlight "gpg.*[1-9]\.[0-9]\..*"

# setup test identity
./setup-gpg-user.sh Alice
export GNUPGHOME=Alice

# Show key. E=encryption, S=signing, C=certification, A=authentication
# (see https://unix.stackexchange.com/a/230859)
run gpg --list-keys alice@example.com
run gpg --list-secret-keys alice@example.com
# (You can also use key ID/fingerprint instead of email.)

# To see key details, including trust value, use --edit-key dialog
run gpg --batch --edit-key alice@example.com quit

# For some reason private key files (stored in `private-keys-v1.d`)
# are named with "keygrips", not key IDs
run ls -l $GNUPGHOME/private-keys-v1.d/
run gpg --list-keys --with-keygrip alice@example.com

# Create an ASCII-armored encrypted message (key ID can be used for --recipient, too)
echo "encryption test" > $GNUPGHOME/test-message
run gpg --armor --encrypt --recipient alice@example.com $GNUPGHOME/test-message
cat $GNUPGHOME/test-message.asc; echo

# Decrypt the message (gpg will prompt for key passphrase)
# Note that the key ID mentioned is the ID of *encryption subkey*, not main key
run gpg --decrypt $GNUPGHOME/test-message.asc
run gpg --list-keys --with-subkey-fingerprint alice@example.com
