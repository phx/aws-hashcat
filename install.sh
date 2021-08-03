#!/bin/bash

if [[ $UID -eq 0 ]]; then
  echo 'Please run this script without sudo as a non-root user.'
  exit 1
fi

cd $(cd -P -- "$(dirname -- "$0")" && pwd -P)
scriptdir="$PWD"
dir='/etc/awshashcat'

echo -e '\nChecking hashcat readiness...'
sudo mkdir -p "$dir"

# STAGE 1/3
if [[ ! -f "${dir}/00_install.LCK" ]]; then
  echo -e "\n${scriptdir}/install.sh\n" >> "${HOME}/.bashrc"
  sudo apt update -y
  sudo apt dist-upgrade -y
  echo '
System will go down for 3 reboots during the upgrade/installation process.
You will have to login for the 2nd and 3rd reboots to complete.
Upon your 3rd time logging in, you should be ready to get cracking.

System going down for reboot [1/3]...
'
  sudo touch "${dir}/00_install.LCK"
  sleep 5
  sudo reboot
fi

# STAGE 2/3
if [[ ! -f "${dir}/01_drivers.LCK" ]]; then
  echo -e '\nConfiguring drivers...\n'
  sudo "${scriptdir}/scripts/01_drivers.sh"
  echo -e '\nSystem going down for reboot [2/3]...\n'
  sudo touch "${dir}/01_drivers.LCK"
  sleep 5
  sudo reboot
fi

# STAGE 3/3
if [[ ! -f "${dir}/02_cuda.LCK" ]]; then
  echo -e '\nInstalling cuda...\n'
  sudo "${scriptdir}/scripts/02_cuda.sh"
  echo -e '\nSystem going down for reboot [3/3]...\n'
  sudo touch "${dir}/02_cuda.LCK"
  sleep 5
  sudo reboot
fi

echo -e '\nhashcat is ready.'

echo -e "\nTo check nvidia status, run 'sudo nvidia-smi'.\n"
