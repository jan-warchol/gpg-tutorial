#!/bin/bash

source utils.sh

# Alice's key is signed by Bob
bob_does \
  gpg --check-signatures alice@example.com | highlight "Bob"

# Bob exports Alice's key with his signature and gives it to Alice
bob_does \
  gpg --armor --export alice@example.com > alice-signed-by-bob.pub
alice_does \
  gpg --import alice-signed-by-bob.pub

# Alice has Bob's signature, but doesn't have his key to check it
alice_does \
  gpg --check-signatures alice@example.com | highlight "signature not checked"
bob_does \
  gpg --armor --export bob@example.com > bob.pub
alice_does \
  gpg --import bob.pub

# Now Alice can see her key was signed by Bob
alice_does \
  gpg --check-signatures alice@example.com | highlight "Bob"
