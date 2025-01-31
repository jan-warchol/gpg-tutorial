#!/bin/bash

./setup-test-gpg-user.sh Alice
export GNUPGHOME=Alice
source utils.sh

# Simple export
#
# GPG's export option is a straightforward approach to backup a key. However:
# - This does not export trust settings.
# - Exporting and importing private keys prompts for password, because
#   they have to be converted to OpenPGP format and reencrypted.

# By default export option exports just the public key.
gpg -a --export Alice > alice.pub

# Export both private and public keys (primary and subkeys).
gpg -a --export-secret-keys Alice > alice-private.asc

# Export only private subkeys and all public keys (primary and subkeys).
gpg -a --export-secret-subkeys Alice > alice-subkeys.asc

# Import keys (public, private, primary, subkeys...) from file.
gpg --import alice-private.asc


# Full synchronization
#
# The following steps can be used not only to make a backup, but also
# for two-way synchronization.

source_dir=Alice
backup_dir=backup
target_dir=import
mkdir -pm 700 $target_dir $backup_dir
mkdir -pm 700 $target_dir/private-keys-v1.d/ $target_dir/openpgp-revocs.d/

# Export private keys, public keys, revocation certs and trust settings
export GNUPGHOME=$source_dir
cp -a $source_dir/private-keys-v1.d $backup_dir/private-keys-v1.d
cp -a $source_dir/openpgp-revocs.d $backup_dir/openpgp-revocs.d
gpg --export --armor > $backup_dir/pubring.asc
gpg --export-ownertrust > $backup_dir/trust-values

# Restoring from backup
export GNUPGHOME=$target_dir
cp -a $backup_dir/private-keys-v1.d/* $target_dir/private-keys-v1.d/
cp -a $backup_dir/openpgp-revocs.d/* $target_dir/openpgp-revocs.d/
# Without data from pubring, restored private keys won't be listed!
log_and_run  gpg --list-secret-keys
log_and_run  gpg --import $backup_dir/pubring.asc
# We need trust data to know the validity of the keys.
log_and_run  gpg --list-secret-keys Alice  | highlight "unknown"
log_and_run  gpg --import-ownertrust $backup_dir/trust-values
log_and_run  gpg --list-secret-keys Alice  | highlight "\[........\]"
