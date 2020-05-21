Learn GPG by doing
------------------

This tutorial will walk you through typical GPG workflow: generating, signing,
trusting, renewing and backing up keys. Instead of long explanations it just
shows what happens in practice on test data.

**Important:** older GPG versions behave significantly different and use
different formats for storing data. This tutorial was tested with GPG
**2.2.4**; you can check your version using `gpg --version`.

### How this works

Setting environment variable `GNUPGHOME` tells GPG to use a different directory
for the data, allowing us to experiment safely without affecting your real
keyring (stored by default in `~/.gnupg`).

### Usage

Running `./setup-gpg-user John` will create a GPG folder named `John` and
generate there a key with UID `John`, email `john@example.com` and passphrase
`I am John`. To work with this keyring, run `export GNUPGHOME=John`.

The recommended way of going through this tutorial is to retype (or copy-paste)
the commands from each script into your terminal. (You can also execute these
scripts, but this will run everything at once.) Note: `run`, `alice_does`,
`bob_does` are simple wrappers for displaying the command before its output
(and setting `GNUPGHOME` appropriately).

In exercises simulating multiple users, I suggest opening separate terminal for
each user, so that you don't have to change `GNUPGHOME` all the time.
