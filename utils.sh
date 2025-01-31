bold="\e[1;97m"
yellow="\e[33;1m"
reset="\e[0m"

# helpers for displaying commands (use stderr to avoid mixing with actual output)
log_and_run() {
  echo -e "${bold}>>> $@ ${reset}" >&2; eval "$@"; echo "" >&2;
}

alice_runs() {
  echo -e "${bold}> Alice runs:  $@ ${reset}" >&2
  eval "GNUPGHOME=Alice $@"
  echo "" >&2
}

bob_runs() {
  echo -e "${bold}> Bob runs:  $@ ${reset}" >&2
  eval "GNUPGHOME=Bob $@"
  echo "" >&2
}

eve_runs() {
  echo -e "${bold}> Eve runs:  $@ ${reset}" >&2
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
export PS1="GNUPGHOME=${yellow}\$GNUPGHOME${reset} $PS1"
