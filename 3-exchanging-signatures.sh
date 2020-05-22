#!/bin/bash

source utils.sh

# Alice's key is signed by Bob
bob_runs  gpg --check-signatures alice@example.com  | highlight "Bob"

# Bob exports Alice's key with his signature and gives it to Alice
bob_runs  gpg --armor --export alice@example.com > alice-signed-by-bob.pub
alice_runs  gpg --import alice-signed-by-bob.pub

# Now Alice can also see her key was signed by Bob
alice_runs  gpg --check-signatures alice@example.com  | highlight "Bob"
