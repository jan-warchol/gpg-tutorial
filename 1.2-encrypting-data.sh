#!/bin/bash

./setup-test-gpg-user.sh Alice
export GNUPGHOME=Alice
source utils.sh


# Create a file with sample data.
echo "My secret data" > example
# Remove files from previous runs.
rm -f example.gpg example.asc example_signed.asc


# Encryption

# When encrypting, you must specify the recipient (who should be able to
# read the data). You can use name, email or key fingerprint for that.

# Encrypt a file using binary format (short options: -e -r)
log_and_run  gpg --encrypt --recipient Alice example
log_and_run  file example.gpg

# Encrypt in an ASCII-encoded ("armored") format (short option: -a)
log_and_run  gpg --armor -e -r Alice example
log_and_run  file example.asc
log_and_run  cat example.asc

# Encrypt and sign the data (short option: -s)
log_and_run  gpg --sign -a -e -r Alice --output example_signed.asc example
log_and_run  cat example_signed.asc

# Notes:
# - the original file remains on disk
# - all options must be specified before input file name
# - signed file is longer than the one without signature


# Decryption

# Decrypt data (gpg will prompt for key passphrase):
log_and_run  gpg -d example.gpg
log_and_run  gpg -d example.asc

# Note: ID mentioned here is the ID of the *encryption subkey*, not main key.
log_and_run  gpg -d example.asc  |& highlight "[0-9A-F]{16,}"
log_and_run  gpg -k --keyid-format long  |& highlight "\/[0-9A-F]{16}"

# GPG displays signature automatically if present.
log_and_run  gpg -d example_signed.asc  |& highlight "signature"
