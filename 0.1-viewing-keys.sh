#!/bin/bash

source utils.sh

# This tutorial was tested with GPG 2.2.
# Check your version; you may have to use `gpg2` command to get GPG v2
log_and_run  gpg --version  | highlight "gpg.*[1-9]\.[0-9]\..*"

# Create test identity
./setup-test-gpg-user.sh Alice
export GNUPGHOME=Alice

# View all known keys (yours and other people). Short option: -k
log_and_run  gpg --list-keys  | highlight "^pub|sub"
# View all available secret keys (~= your keys). Short option: -K
log_and_run  gpg --list-secret-keys  | highlight "^sec|ssb"

# Legend:
# pub = primary public key
# sub = subkey
# uid = user identity (many identities can be tied to one key)
# sec = secret key
# ssb = secret subkey
# Key capabilities: C=certification, E=encryption, S=signing, A=authentication

# View specific key (you can use name, email, key fingerprint or long ID):
log_and_run  gpg -k Alice

# Show subkey fingerprints:
log_and_run  gpg -k --with-subkey-fingerprint

# Include expired and revoked subkeys:
log_and_run  gpg -k --list-options show-unusable-subkeys

# Show fingerprints in an easy-to-read, space-separated format:
log_and_run  gpg -k --fingerprint

# Show keygrips, which are used for private key filenames:
log_and_run  gpg -K --with-keygrip
log_and_run  ls -l $GNUPGHOME/private-keys-v1.d/

# To see more details, including trust value, use --edit-key dialog:
log_and_run  gpg --edit-key Alice quit
