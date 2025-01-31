#!/bin/bash

./setup-test-gpg-user.sh Alice 1w
./setup-test-gpg-user.sh Bob 3w

# Open two terminals - one for Alice:
source utils.sh
export GNUPGHOME=Alice

# ...and one for Bob:
source utils.sh
export GNUPGHOME=Bob

# Bob writes a message to Alice and he wants to encrypt it
bob_runs  echo "Hi Alice, Bob here." > msg-to-alice

# Bob finds a public key that has Alice's name on it
bob_runs  gpg --import alice.pub
# However, that key is not verifed yet - its validity is reported as "unknown"
bob_runs  gpg --list-keys  | highlight "unknown"

# Trying to encrypt with invalid key will show a warning
# (answer "no" to the prompt!)
bob_runs  gpg --encrypt --recipient alice@example.com msg-to-alice

# Alice's key is self-signed - but that signature doesn't prove anything
bob_runs  gpg --check-signatures alice@example.com  | highlight "  Alice"
