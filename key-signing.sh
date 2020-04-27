./gpg-user-setup.sh Alice
./gpg-user-setup.sh Bob

GNUPGHOME=Alice \
gpg --armor --export alice@example.com > alice.pub

GNUPGHOME=Bob \
gpg --import alice.pub
echo

# Note that Alice's key is marked "unknown"
GNUPGHOME=Bob \
gpg --list-keys

# encrypting will show a warning because Alice's key needs to be verified
echo msg from Bob to Alice | GNUPGHOME=Bob gpg -a -e -r alice@example.com | tee bob-to-alice.asc
echo

# The only signature is Alice's own, but we don't
GNUPGHOME=Bob \
gpg --check-signatures alice@example.com
echo

# Alice tells her key fingerprint to Bob
GNUPGHOME=Alice \
gpg --fingerprint alice@example.com

# Bob signs the key verifying fingerprint with what Alice said
GNUPGHOME=Bob \
gpg --sign-key alice@example.com

# Now encryption should work
echo msg from Bob to Alice | GNUPGHOME=Bob gpg -a -e -r alice@example.com | tee bob-to-alice.asc
echo

# And Alice is able to decrypt the message
GNUPGHOME=Alice \
gpg -d bob-to-alice.asc
echo

# Now Alice's key is signed by Bob
GNUPGHOME=Bob \
gpg --check-signatures alice@example.com
echo

# Bob exports Alice's key with his signature and gives it to Alice
GNUPGHOME=Bob \
gpg --armor --export alice@example.com > alice-signed.pub

# Alice imports Bob's signature
GNUPGHOME=Alice \
gpg --import alice-signed.pub
echo

# Alice has Bob's signature, but doesn't have his key to check it
GNUPGHOME=Alice \
gpg --check-signatures alice@example.com
echo

GNUPGHOME=Bob \
gpg --armor --export bob@example.com > bob.pub

GNUPGHOME=Alice \
gpg --import bob.pub
echo

# Now Alice can see her key is verified by Bob
GNUPGHOME=Alice \
gpg --check-signatures alice@example.com
echo
