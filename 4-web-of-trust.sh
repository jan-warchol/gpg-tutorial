#!/bin/bash

./setup-gpg-user.sh Eve 5w
source utils.sh

# Eve exports her public key and puts it on her website.
# Bob and Alice both import it.
eve_runs  gpg --armor --export eve@example.com > eve.pub
alice_runs  gpg --import eve.pub
bob_runs  gpg --import eve.pub

# Alice meets Eve in person, gets her key fingerprint and signs the key.
alice_runs  gpg --quick-sign-key $(cat Eve/key-id)
alice_runs  gpg --check-signatures eve@example.com  | highlight "Alice"

# Bob cannot meet Eve in person, but he trusts Alice (select "full" or
# "marginal" trust, confirm with "save"). He asks for Eve's key signed by
# Alice; the validity of that key corresponts to Bob's trust in Alice.
bob_runs  gpg --edit-key alice@example.com trust
alice_runs  gpg --armor --export eve@example.com > eve-signed-by-alice.pub
bob_runs  gpg --import eve-signed-by-alice.pub
bob_runs  gpg --check-signatures eve@example.com  |
              highlight "Alice" | highlight "\[........\]"
