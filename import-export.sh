run() {
  echo -e "\e[1;37m>>>> $@ \e[0m" >&2
  eval "$@"; echo "" >&2
}
highlight() {
  sed -E "s/($@)/[1;33m\1[0m/g"
}

src_dir=Bob
backup_dir=backup
target_dir=import
mkdir -pm 700 $target_dir $backup_dir

export GNUPGHOME=$src_dir
cp -a $src_dir/openpgp-revocs.d $backup_dir/openpgp-revocs.d
# We could export private keys like this:
#     gpg --export-secret-keys --armor > $backup_dir/private-keys.asc
# but this would prompt for password (because they have to be converted
# to OpenPGP format and reencrypted). Instead, we can simply copy files:
cp -a $src_dir/private-keys-v1.d $backup_dir/private-keys-v1.d
gpg --export --armor > $backup_dir/pubring.asc
gpg --export-ownertrust > $backup_dir/trust-values


export GNUPGHOME=$target_dir
# restore private keys and revocation certificates
cp -a $backup_dir/private-keys-v1.d $target_dir/private-keys-v1.d
cp -a $backup_dir/openpgp-revocs.d $target_dir/openpgp-revocs.d
# at this moment keys are not listed yet, we need data from pubring
run gpg --list-keys

run gpg --import $backup_dir/pubring.asc
# keys are listed as unknown because there are no known trusted keys
run gpg --list-keys | highlight "unknown"

# after restoring trust values everything is back
run gpg --import-ownertrust $backup_dir/trust-values
run gpg --list-keys | highlight "\[........\]"

