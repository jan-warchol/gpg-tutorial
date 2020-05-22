# helpers for displaying commands (use stderr to avoid mixing with actual output)
run() {
  echo -e "\e[1;37m>>> $@ \e[0m" >&2; eval "$@"; echo "" >&2;
}

alice_runs() {
  echo -e "\e[1;37m> Alice runs:  $@ \e[0m" >&2
  eval "GNUPGHOME=Alice $@"
  echo "" >&2
}

bob_runs() {
  echo -e "\e[1;37m> Bob runs:  $@ \e[0m" >&2
  eval "GNUPGHOME=Bob $@"
  echo "" >&2
}

eve_runs() {
  echo -e "\e[1;37m> Eve runs:  $@ \e[0m" >&2
  eval "GNUPGHOME=Eve $@"
  echo "" >&2
}

# for simulating key expiry
future_gpg(){
  gpg --faked-system-time $(date -d "+2 weeks" +%s) "$@"
}

# helper for visually marking important parts of output
highlight() {
  sed -E "s/($@)/[1;33m\1[0m/g"
}

# show current value of GPG home in bold yellow
export PS1="GNUPGHOME=\e[33;1m\$GNUPGHOME\e[0m $PS1"
