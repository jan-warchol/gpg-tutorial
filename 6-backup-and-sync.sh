#!/bin/bash

source utils.sh
./setup-gpg-user.sh Bob 3w

# We can backup GPG by simply copying the files. This is the best approach in
# case of private keys, which never change. However, for pubring and trustdb
# (which contain information about validity and trust of keys you've collected)
# it's better to use export and import - this allows two-directional sync.
# NOTE: older versions of GPG use a completely different storage format!

source_dir=Bob
backup_dir=backup
target_dir=import
mkdir -pm 700 $target_dir $backup_dir

export GNUPGHOME=$source_dir
# Note: exporting and importing private keys would prompt for password, because
# they would have to be converted to OpenPGP format and reencrypted.
cp -a $source_dir/private-keys-v1.d $backup_dir/private-keys-v1.d
cp -a $source_dir/openpgp-revocs.d $backup_dir/openpgp-revocs.d
gpg --export --armor > $backup_dir/pubring.asc
gpg --export-ownertrust > $backup_dir/trust-values

export GNUPGHOME=$target_dir
cp -a $backup_dir/private-keys-v1.d $target_dir/private-keys-v1.d
cp -a $backup_dir/openpgp-revocs.d $target_dir/openpgp-revocs.d
# Note: without data from pubring restored private keys won't be listed!
run  gpg --list-keys
run  gpg --import $backup_dir/pubring.asc

# We need trust data to know the validity of the keys (even local private keys
# are not trusted by default)
run  gpg --list-keys  | highlight "unknown"
run  gpg --import-ownertrust $backup_dir/trust-values
run  gpg --list-keys  | highlight "\[........\]"

# synchronizing GPG databases is a matter of exporting/importing pubring and
# trustdb, and occasional sync of private-keys-v1.d if we add new keys.
