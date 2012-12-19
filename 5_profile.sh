#!/bin/bash

echo ""
echo "*** Setup Profile"
echo ""

# Read config file
. ./setup.cfg

echo "* Add Aliases"

cat <<EOF > /home/$username/.bash_aliases
alias vhosts='cd $vhosts'
alias free="free -m"
alias aptitude="sudo aptitude"
alias update="sudo aptitude update"
alias upgrade="sudo aptitude safe-upgrade"
alias install="sudo aptitude install"
alias remove="sudo aptitude remove"
alias clean="sudo aptitude autoclean"
EOF

echo "* Add Command Line Styling"

cat <<EOF > /home/$username/.bash_profile
export PS1='\[\033[0;35m\]\h\[\033[0;33m\] \w\[\033[00m\]: '
EOF
