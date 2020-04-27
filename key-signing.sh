./gpg-user-setup.sh Alice
./gpg-user-setup.sh Bob

# helpers for displaying commands (on stderr to avoid mixing with actual output)
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

# helpers for visually marking important parts of output
highlight() {
  sed -E "s/($@)/[1;33m\1[0m/g"
}
hi_fingerprint() {
  sed -E "s/([0-9A-F ]{16,})/[1;33m\1[0m/g"
}

# Bob writes a message to Alice and he wants to encrypt it
bob_does echo "Hi Alice, Bob here." > msg-to-alice

# He gets Alice's public key
alice_does \
gpg --armor --export alice@example.com > alice.pub
bob_does \
gpg --import alice.pub

# Note that Alice's key is marked "unknown" (it's not verified)
bob_does \
gpg --list-keys | highlight "unknown"

# Because of that trying to encrypt with it will show a warning
bob_does \
gpg --armor --encrypt --recipient alice@example.com msg-to-alice

# Alice's key is self-signed - that signature doesn't prove anything
bob_does \
gpg --check-signatures alice@example.com | highlight "sig.*Alice"

# Alice tells her key fingerprint to Bob (in person or in other really secure way)
alice_does \
gpg --fingerprint alice@example.com | hi_fingerprint

# Bob verifies the fingerprint and, if it matches, signs the key with his own key
# (confirming this key really belongs to Alice)
bob_does \
gpg --sign-key alice@example.com

# Now Alice's key is marked as verified
bob_does \
gpg --list-keys alice@example.com | highlight "full"

# And encryption will work without warning
bob_does \
gpg -a -e -r alice@example.com msg-to-alice
cat msg-to-alice.asc; echo

# And Alice is able to decrypt the message
alice_does \
gpg -d msg-to-alice.asc

# Now Alice's key is signed by Bob
bob_does \
gpg --check-signatures alice@example.com | highlight "bob@example.com"

# Bob exports Alice's key with his signature and gives it to Alice
bob_does \
gpg --armor --export alice@example.com > alice-signed.pub

# Alice imports Bob's signature
alice_does \
gpg --import alice-signed.pub

# Alice has Bob's signature, but doesn't have his key to check it
alice_does \
gpg --check-signatures alice@example.com | highlight "signature not checked"

bob_does \
gpg --armor --export bob@example.com > bob.pub

alice_does \
gpg --import bob.pub

# Now Alice can see her key is verified by Bob
alice_does \
gpg --check-signatures alice@example.com | highlight "bob@example.com"
