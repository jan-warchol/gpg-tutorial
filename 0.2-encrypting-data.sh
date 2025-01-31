#!/bin/bash

source utils.sh

# create test identity
./setup-test-gpg-user.sh Ala
export GNUPGHOME=Ala


# Create a file with sample data.
log_and_run  echo "My secret data" > my_data

# Encrypt a file using binary format (short options: -e -r)
# Note that recipient name must follow -r.
# Note that the original file remains on disk.
log_and_run  gpg --encrypt --recipient Ala my_data
log_and_run  ls -l my_data.gpg

# Encrypt in an ASCII-armored format (short option: -a)
log_and_run  gpg --armor -er Ala my_data
log_and_run  cat my_data.asc

# Encrypt and sign the data (short option: -s)
# Note that all options must be specified before input file
log_and_run  gpg --sign -aer Ala --output data_signed.asc my_data 
log_and_run  cat data_signed.asc
# notice that the file is longer than the one without signature


# Decrypt data:
log_and_run gpg -d my_data.gpg
log_and_run gpg -d my_data.asc
log_and_run gpg -d data_signed.asc |& highlight "signature"
