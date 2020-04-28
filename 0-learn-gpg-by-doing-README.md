Learn GPG by doing
------------------

This tutorial will walk you through typical GPG workflow: generating, signing,
trusting, renewing and backing up keys. Instead of long explanations it just shows what happens in practice on test data.

**Important:** older GPG versions behave significantly different and use
different formats for storing data. This tutorial was tested with GPG
**2.2.4**.

Notes:
- you can use key ID/fingerprint excahngeably with email
- always set expiration date for your keys (typically 1-2 years)
- running `./setup-gpg-user "John Doe"` will create GPG directory `John Doe`
  and generate a key with UID `John Doe` and email `john-doe@example.com` 
- commands `run`, `alice_does`, `bob_does` are just simple helpers for
  displaying command before its output
