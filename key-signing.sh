./gpg-user-setup.sh Alice
./gpg-user-setup.sh Bob

# helpers for showing commands (on stderr to avoid mixing with actual output)
alice_does() {
  echo -e "\e[1;37m> Alice runs:  $@ \e[0m" >&2
  eval "GNUPGHOME=Alice $@"
  echo "" >&2
}
bob_does() {
  echo -e "\e[1;37m> Bob runs:  $@ \e[0m" >&2
  eval "GNUPGHOME=Bob $@"
  echo "" >&2
}

alice_does \
gpg --armor --export alice@example.com > alice.pub
ll alice.pub

bob_does \
gpg --import alice.pub

# Note that Alice's key is marked "unknown"
bob_does \
gpg --list-keys

# encrypting will show a warning because Alice's key needs to be verified
echo msg from Bob to Alice | GNUPGHOME=Bob gpg -a -e -r alice@example.com | tee bob-to-alice.asc

# The only signature is Alice's own, but we don't
bob_does \
gpg --check-signatures alice@example.com

# Alice tells her key fingerprint to Bob
alice_does \
gpg --fingerprint alice@example.com

# Bob signs the key verifying fingerprint with what Alice said
bob_does \
gpg --sign-key alice@example.com

# Now encryption should work
echo msg from Bob to Alice | GNUPGHOME=Bob gpg -a -e -r alice@example.com | tee bob-to-alice.asc

# And Alice is able to decrypt the message
alice_does \
gpg -d bob-to-alice.asc

# Now Alice's key is signed by Bob
bob_does \
gpg --check-signatures alice@example.com

# Bob exports Alice's key with his signature and gives it to Alice
bob_does \
gpg --armor --export alice@example.com > alice-signed.pub

# Alice imports Bob's signature
alice_does \
gpg --import alice-signed.pub

# Alice has Bob's signature, but doesn't have his key to check it
alice_does \
gpg --check-signatures alice@example.com

bob_does \
gpg --armor --export bob@example.com > bob.pub

alice_does \
gpg --import bob.pub

# Now Alice can see her key is verified by Bob
alice_does \
gpg --check-signatures alice@example.com
