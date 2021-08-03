#!/bin/bash

sudo apt update -y && sudo apt install -y git &&\
mkdir "$HOME/git" && cd "$HOME/git" &&\
git clone https://github.com/phx/aws-hashcat &&\
source "$HOME/git/aws-hashcat/scripts/01_install.sh"

