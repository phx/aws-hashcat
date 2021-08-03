#!/bin/bash

mkdir -p "$HOME/git" && cd "$HOME/git" &&\
git clone https://github.com/phx/aws-hashcat &&\
source "$HOME/git/aws-hashcat/scripts/01_install.sh"

