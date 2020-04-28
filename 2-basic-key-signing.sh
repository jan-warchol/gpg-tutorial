#!/bin/bash

./setup-gpg-user.sh Alice 1w
./setup-gpg-user.sh Bob 3w
source utils.sh

# Bob writes a message to Alice and he wants to encrypt it
bob_does echo "Hi Alice, Bob here." > msg-to-alice

# He gets Alice's public key
alice_does \
  gpg --armor --export alice@example.com > alice.pub
bob_does \
  gpg --import alice.pub

# Note that Alice's key is marked "unknown" (it's not verified)
# Because of that trying to encrypt with it will show a warning
bob_does \
  gpg --list-keys | highlight "unknown"
bob_does \
  gpg --armor --encrypt --recipient alice@example.com msg-to-alice

# Alice's key is self-signed - that signature doesn't prove anything
bob_does \
  gpg --check-signatures alice@example.com | highlight "  Alice"

# Alice tells her key fingerprint to Bob (in person or in other really secure way)
# Bob verifies the fingerprint and, if it matches, signs the key with his own key
# (confirming this key really belongs to Alice)
alice_does \
  gpg --fingerprint alice@example.com | hi_fingerprint
bob_does \
  gpg --sign-key alice@example.com

# Now Alice's key is marked as verified and encryption will work without warning
bob_does \
  gpg --list-keys alice@example.com | highlight "full"
bob_does \
  gpg -a -e -r alice@example.com msg-to-alice
cat msg-to-alice.asc
