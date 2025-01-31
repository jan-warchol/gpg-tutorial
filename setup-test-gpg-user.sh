#!/bin/bash

# Parse arguments and construct user parameters
[ $# -lt 1 ] && echo "Usage: $0 <user name> [<key valid for>]" && exit 1

USER_NAME="$1"
NAME_SLUG="$(echo $USER_NAME | sed -E s/[^a-zA-Z0-9]+/-/g | tr A-Z a-z )"
USER_EMAIL="$NAME_SLUG@example.com"
USER_PASS="$(echo $USER_NAME | tr A-Z a-z)"
KEY_EXPIRY="${2:-1w}"

bold="\e[1;97m"
reset="\e[0m"

# Setup a dedicated directory for testing, don't mess with ~/.gnupg
BASE_DIR="$(dirname $(readlink --canonicalize "$0"))"
GNUPGHOME="$BASE_DIR/$USER_NAME"
LOG_FILE="$GNUPGHOME/tutorial-setup.log"
mkdir -p -m 700 "$GNUPGHOME"
export GNUPGHOME

# Only run actual key generation if it wasn't done before
if [ -e "$LOG_FILE" ]; then
  echo "GPG home for $USER_NAME already exists, nothing to do."; echo; exit;
fi

echo -e "GPG data belonging to $USER_NAME will be stored in ${bold}${GNUPGHOME}${reset}".
echo
echo "Generating new key for $USER_NAME <$USER_EMAIL> (this may take some time):"
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
gpg --check-trustdb
echo

# Cache some information for other scripts
echo -e "Generated key with ID ${bold}${KEY_ID}${reset}"
echo -e "and passphrase \"${bold}${USER_PASS}${reset}\"."
echo Writing down key ID to $GNUPGHOME/key-id.
echo $KEY_ID > "$GNUPGHOME/key-id"
gpg --export $USER_EMAIL > $NAME_SLUG.pub
