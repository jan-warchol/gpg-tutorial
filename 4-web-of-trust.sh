#!/bin/bash

./setup-gpg-user.sh Eve

source utils.sh

# Eve exports her public key and puts it on her website.
# Bob and Alice both import it.
eve_does   gpg --armor --export eve@example.com > eve.pub
alice_does gpg --import eve.pub
bob_does   gpg --import eve.pub

# Alice meets Eve in person, gets her key fingerprint and signs the key.
alice_does gpg --quick-sign-key $(cat Eve/key-id)
alice_does gpg --check-signatures eve@example.com | highlight "Alice"

# Bob cannot meet Eve in person, but he trusts Alice (select "full" or
# "marginal" trust, confirm with "save"). He asks for Eve's key signed by
# Alice; the validity of that key corresponts to Bob's trust in Alice.
bob_does   gpg --edit-key alice@example.com trust
alice_does gpg --armor --export eve@example.com > eve-signed-by-alice.pub
bob_does   gpg --import eve-signed-by-alice.pub
bob_does   gpg --check-signatures eve@example.com |
               highlight "Alice" | highlight "\[........\]"
