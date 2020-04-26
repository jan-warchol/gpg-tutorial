# exporting and encrypting with a specific subkey requires exclamation mark
gpg -a --export-secret-keys 82000DD4E25AF4C2EBC47EBCA81290B7B136DF19! > B7B136DF19-subkey.key # BUT THIS ALSO INCLUDES MASTER KEY!!
gpg -a --export-secret-subkeys 82000DD4E25AF4C2EBC47EBCA81290B7B136DF19! > B7B136DF19-subkey.key # this works as expected
echo test msg | gpg -a -e -r 82000DD4E25AF4C2EBC47EBCA81290B7B136DF19! > to-B136DF19.asc

# pass also needs !
# note: by default last subkey is used.

# additional user identities
gpg --batch --quick-add-uid $KEY_ID "Alternate Identity <mysterious@man.com>"
gpg --list-keys $KEY_ID

# highlighting
gpg --list-keys --with-subkey-fingerprint $KEY_ID | grep --context=5 -E "[0-9A-F ]{16,}"
