#!/bin/bash

# Parse arguments and construct user parameters
[ $# -lt 1 ] && echo "Usage: $0 <user name> [<key valid for>]" && exit 1

USER_NAME="$1"
NAME_SLUG="$(echo $USER_NAME | sed -E s/[^a-zA-Z0-9]+/-/g | tr A-Z a-z )"
USER_EMAIL="$NAME_SLUG@example.com"
USER_PASS="I am $USER_NAME"
KEY_EXPIRY="${2:-1w}"

# Setup a dedicated directory for testing, don't mess with ~/.gnupg
BASE_DIR="$(dirname $(readlink --canonicalize "$0"))"
GNUPGHOME="$BASE_DIR/$USER_NAME"
LOG_FILE="$GNUPGHOME/tutorial-setup.log"
mkdir -p -m 700 "$GNUPGHOME"
export GNUPGHOME
echo -e "GPG data belonging to $USER_NAME will be stored in \e[1;37m$GNUPGHOME\e[0m".

# Only run actual key generation if it wasn't done before
if [ -e "$LOG_FILE" ]; then
  echo "GPG home for $USER_NAME already exists, nothing to do."; echo; exit;
fi

echo; echo "Generating new key for $USER_NAME <$USER_EMAIL>:"
# Log to a file for later reference (e.g. to get ID after script finished).
# Note: keys are short because performance > security for testing purposes
gpg --batch --generate-key --logger-file "$LOG_FILE" <<EOF
  Key-Type: default
  Key-Length: 1024
  Subkey-Type: default
  Subkey-Length: 1024
  Name-Real: $USER_NAME
  Name-Email: $USER_EMAIL
  Passphrase: $USER_PASS
  Expire-Date: $KEY_EXPIRY
EOF
cat "$LOG_FILE"
echo

KEY_ID=$(tail -1 "$LOG_FILE" | grep -Eo "[0-9A-F]{40}")

# Trigger database maintenance (could be confusing if it appears on its own)
gpg --check-trustdb; echo

# Cache some information for other scripts
echo -e "Generated key with ID \e[1;37m$KEY_ID\e[0m"
echo -e "and passphrase \e[1;37m$USER_PASS\e[0m."
echo Writing down key ID to $GNUPGHOME/key-id.
echo $KEY_ID > "$GNUPGHOME/key-id"
