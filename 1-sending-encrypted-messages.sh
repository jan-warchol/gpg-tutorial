#!/bin/bash

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
# However, that key is not verifed yet - trying to encrypt with it
# will show a warning (answer "no" to the prompt!)
bob_runs  gpg --armor --encrypt --sign --recipient alice@example.com msg-to-alice

# Keys that haven't been verified have their validity set to "unknown"
bob_runs  gpg --list-keys  | highlight "unknown"
# Alice's key is self-signed - but that signature doesn't prove anything
bob_runs  gpg --check-signatures alice@example.com  | highlight "  Alice"
