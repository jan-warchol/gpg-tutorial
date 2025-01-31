#!/bin/bash

source utils.sh

# This tutorial was tested with GPG 2.2.
# Check your version; you may have to use `gpg2` command to get GPG v2
log_and_run  gpg --version  | highlight "gpg.*[1-9]\.[0-9]\..*"

# create test identity
./setup-test-gpg-user.sh Alice
export GNUPGHOME=Alice

# View all known keys (yours and other people):
log_and_run  gpg --list-keys   # short option: -k
# View all available secret keys (~= your keys):
log_and_run  gpg --list-secret-keys   # short option: -K

# Legend:
# pub = primary public key
# sub = subkey
# uid = user identity (many identities can be tied to one key)
# sec = secret key
# ssb = secret subkey
# Key capabilities: C=certification, E=encryption, S=signing, A=authentication

# To specify a particular key, you can use:
# - email
# - name (as long as it's unambiguous)
# - key fingerprint
# - so-called "long ID" (which is the last 16 digits of the fingerprint)
log_and_run  gpg -k alice@example.com
log_and_run  gpg -k Alice
# log_and_run  gpg -k 789D96645A812D77FB2A17652FA3EB4C3EED2C95
# log_and_run  gpg -k 2FA3EB4C3EED2C95

# Show subkey fingerprints:
log_and_run  gpg -k --with-subkey-fingerprint

# Include expired and revoked subkeys:
log_and_run  gpg -k --list-options show-unusable-subkeys

# Show fingerprints in an easy-to-read, space-separated format:
log_and_run  gpg -k --fingerprint
