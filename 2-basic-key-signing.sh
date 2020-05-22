#!/bin/bash

# Open two terminals - one for Alice:
./setup-gpg-user.sh Alice 1w
source utils.sh
export GNUPGHOME=Alice

# ...and one for Bob:
./setup-gpg-user.sh Bob 3w
source utils.sh
export GNUPGHOME=Bob

# Bob writes a message to Alice and he wants to encrypt it
bob_runs echo "Hi Alice, Bob here." > msg-to-alice

# He gets Alice's public key
alice_runs  gpg --armor --export alice@example.com > alice.pub
bob_runs  gpg --import alice.pub

# At this moment Alice's key is marked "unknown" (it's not verified yet)
bob_runs  gpg --list-keys  | highlight "unknown"
# Alice's key is self-signed - but that signature doesn't prove anything
bob_runs  gpg --check-signatures alice@example.com  | highlight "  Alice"
# Because of that trying to encrypt with it will show a warning
# (answer "no" to the prompt)
bob_runs  gpg --armor --encrypt --recipient alice@example.com msg-to-alice

# Alice tells her key fingerprint to Bob (in person or in other secure way)
alice_runs  gpg --fingerprint alice@example.com  | highlight "[0-9A-F ]{16,}"
# Bob signs her key with his own key (check if the fingerprint matches!!),
# confirming this key really belongs to Alice
bob_runs  gpg --sign-key alice@example.com

# Now Alice's key is marked as verified
bob_runs  gpg --list-keys alice@example.com  | highlight "full"
# And encryption works without warning
bob_runs  gpg -a -e -r alice@example.com msg-to-alice
cat msg-to-alice.asc

# Alice can read the message
alice_runs  gpg -d msg-to-alice.asc
