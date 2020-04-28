#!/bin/bash

source utils.sh

future_gpg(){
  gpg --faked-system-time $(date -d "+2 weeks" +%s) "$@"
}

# In two weeks from now, Alice's key will have expired. Since Bob relied on
# Alice's signature for validating Eve's key, that key will also be affected.
bob_does  future_gpg --list-keys | highlight "expired" | highlight "unknown"
alice_does  future_gpg --list-keys | highlight "expired"

# Alice can change expiration date on her key and share the update with Bob.
# (Input new expiration time and then "save"; don't update the subkey yet.)
alice_does  future_gpg --edit-key alice@example.com expire
alice_does  future_gpg --list-keys | highlight "ultimate" | highlight "full"
alice_does  future_gpg --armor --export alice@example.com > alice-extended.pub
bob_does  future_gpg --import alice-extended.pub
bob_does  future_gpg --list-keys | highlight "full" | highlight "marginal"

# However, Bob still gets an error when trying to encrypt a message to Alice.
# Error message is quite misleading, but it means there is no valid key to use.
bob_does  echo "Hi Alice, long time no see." > new-msg-to-alice
bob_does  future_gpg -a -e -r alice@example.com new-msg-to-alice |& highlight "Unusable"

# Alice could extend encryption key, but she can also generate a new subkey.
# Rotating the subkey gives better security but is less convenient.
alice_does  future_gpg --edit-key alice@example.com addkey
alice_does  future_gpg --batch --edit-key alice@example.com check
alice_does  future_gpg --armor --export alice@example.com > alice-new-subkey.pub
bob_does  future_gpg --import alice-new-subkey.pub
bob_does  future_gpg -a -e -r alice@example.com new-msg-to-alice
cat new-msg-to-alice.asc
