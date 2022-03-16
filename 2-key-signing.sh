#!/bin/bash

source utils.sh

# Alice tells her key fingerprint to Bob (in person or in other secure way)
alice_runs  gpg --fingerprint alice@example.com  | highlight "[0-9A-F ]{16,}"
# Bob signs her key with his own key (check if the fingerprint matches!!),
# confirming this key really belongs to Alice
bob_runs  gpg --sign-key alice@example.com

# Now Alice's key is marked as verified
bob_runs  gpg --list-keys alice@example.com  | highlight "full"
# And encryption works without warning
bob_runs  gpg -a -e -s -r alice@example.com msg-to-alice
# Here you can see the encrypted message
cat msg-to-alice.asc; echo

# Alice can read the message
alice_runs  gpg --decrypt msg-to-alice.asc
# However, she can't verify Bob's signature because she doesn't have his key
alice_runs  gpg --decrypt msg-to-alice.asc  |& highlight "No public key"

# Alice gets Bob's key, asks him for its fingerprint, verifies it and signs the key
alice_runs  gpg --import bob.pub
bob_runs  gpg --fingerprint bob@example.com  | highlight "[0-9A-F ]{16,}"
alice_runs  gpg --sign-key bob@example.com
# Now she can verify the signature on the message
alice_runs  gpg -d msg-to-alice.asc  |& highlight "Good signature"
