Learn GPG by doing
------------------

This tutorial will walk you through typical GPG workflow: generating, signing,
trusting, backing up and renewing keys. Instead of long explanations it just
shows what happens in practice on test data - without affecting your real
keyring (which is stored by default in `~/.gnupg`).

**Important:** older GPG versions behave significantly different and use
different storage formats. This tutorial was tested with GPG **2.2.4**;
you can check yours using `gpg --version`.

### How to use this

We will pretend to be two users: Alice and Bob.

1.  Open two terminal windows, one for Alice and one for Bob, and navigate to
    this directory in both.

1.  Create keyrings for them:

        ./setup-gpg-user.sh Alice 1w
        ./setup-gpg-user.sh Bob 3w

1.  Go through the exercise files in order, retyping (or copy-pasting) the
    commands from each script into appropriate terminal. For example, if the
    command is

        bob_runs  gpg --import alice.pub

    then you should run `gpg --import alice.pub` in Bob's terminal.

Note that you can omit the `| highlight ...` parts - they are only for visual aid.
You can also execute the whole script, but this will run everything at once.
