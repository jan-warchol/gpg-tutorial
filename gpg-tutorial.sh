# Use `gpg --help` to list commands and `man gpg` for details.

# check version - does `gpg` command points to GPG v2?
# Otherwise you may have to use `gpg2` command.
echo -n "This script was tested with GPG 2.2.4. Your version: "
gpg --version | grep "gpg.*[1-9]\.[0-9]\."
echo

# Use a dedicated directory for testing, don't mess with ~/.gnupg
export GNUPGHOME="$HOME/gpg-test"
mkdir -p -m 700 $GNUPGHOME
LOG_FILE="$GNUPGHOME/gpg-key-test.log"
# end of initialization -------------------------------------


echo Generating new key:
# Log to a file for later reference (e.g. to get ID after script finished).
# Note: keys are short because performance > security for testing purposes
gpg --batch --generate-key --logger-file $LOG_FILE <<EOF
  Key-Type: default
  Key-Length: 1024
  Subkey-Type: default
  Subkey-Length: 1024
  Name-Real: Test User
  Name-Email: tester@example.com
  Passphrase: weakpass
  Expire-Date: 1w
EOF
tail -2 $LOG_FILE
echo

KEY_ID=$(tail -1 $LOG_FILE | grep -Eo "[0-9A-F]{40}")

# Trigger database maintenance (separate from listing keys)
gpg --check-trustdb
echo

# Show key. E=encryption, S=signing, C=certification, A=authentication
# (see https://unix.stackexchange.com/a/230859)
gpg --list-keys $KEY_ID

# For some reason apart from IDs there are also keygrips
gpg --list-keys --with-keygrip $KEY_ID

# Here you can see actual key files, named after keygrips
ls $GNUPGHOME/private-keys-v1.d/*.key
echo

# Create an ASCII-encoded message encrypted with the new key
echo test message | gpg -a -e -r tester@example.com | tee $GNUPGHOME/test-msg.asc
echo

# Decrypt the message (it will prompt you for key passphrase)
gpg -d $GNUPGHOME/test-msg.asc
echo
# Note the ID in the message above. Does it match your key?

# show subkey fingerprints
gpg --list-keys --with-subkey-fingerprint $KEY_ID
