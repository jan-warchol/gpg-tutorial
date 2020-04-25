# Use `gpg --help` to list commands and `man gpg` for details.

# check version - does `gpg` command points to GPG v2?
# Otherwise you may have to use `gpg2` command.
echo -n "This script was tested with GPG 2.2.4. Your version: "
gpg --version | grep "gpg.*[1-9]\.[0-9]\."
echo

# Use a dedicated directory for testing, don't mess with ~/.gnupg
export GNUPGHOME="$HOME/gpg-test"
mkdir -p -m 700 $GNUPGHOME
LOG_FILE="$GNUPGHOME/gpg-key-test.log"
# end of initialization -------------------------------------
