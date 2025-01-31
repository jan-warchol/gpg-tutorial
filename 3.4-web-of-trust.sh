#!/bin/bash

./setup-test-gpg-user.sh Eve 5w
source utils.sh

# Eve puts her public key on a website (or public keyserver).
# Both Bob and Alice import it.
alice_runs  gpg --import eve.pub
bob_runs  gpg --import eve.pub

# Alice meets Eve in person, gets her key fingerprint and signs the key.
alice_runs  gpg --sign-key eve@example.com
alice_runs  gpg --check-signatures eve@example.com  | highlight "Alice"

# Bob cannot meet Eve in person, but he trusts Alice (select "full" or
# "marginal" trust, confirm with "save").
bob_runs  gpg --edit-key alice@example.com trust
# He asks for Eve's key signed by Alice; the validity of that key corresponds
# to Bob's trust in Alice.
alice_runs  gpg --armor --export eve@example.com > eve-signed-by-alice.pub
bob_runs  gpg --import eve-signed-by-alice.pub
bob_runs  gpg --check-signatures eve@example.com  | highlight "Alice|\[........\]"
