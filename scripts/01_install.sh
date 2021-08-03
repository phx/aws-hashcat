#!/bin/bash

dir='/etc/awshashcat'

echo -e '\nChecking hashcat readiness...\n'
sudo mkdir -p "$dir"

# STAGE 1/3
if [[ ! -f "${dir}/01_install.LCK" ]]; then
  echo 'source $HOME/git/aws-hashcat/scripts/02_drivers.sh' >> ~/.bashrc
  echo 'source $HOME/git/aws-hashcat/scripts/03_cuda.sh' >> ~/.bashrc
  echo -e "\nTo view nvidia console, run 'sudo nvidia-smi'.\n" >> ~/.bashrc
  sudo apt update -y
  sudo apt-distupgrade -y
  echo '
System will go down for 3 reboots during the upgrade/installation process.
You will have to login for the 2nd and 3rd reboots to complete.
Upon your 3rd time logging in, you should be ready to get cracking

System going down for reboot [1/3]...
'
  sudo touch "${dir}/01_install.LCK"
  sleep 5
  sudo reboot
fi

# STAGE 2/3
if [[ ! -f "${dir}/02_drivers.LCK" ]]; then
  echo -e '\nConfiguring drivers...\n'
  sudo "$HOME/git/aws-hashcat/scripts/02_drivers.sh"
  echo 'System going down for reboot [2/3]...'
  sudo touch "${dir}/02_drivers.LCK"
  sleep 5
  sudo reboot
fi

# STAGE 3/3
if [[ ! -f "${dir}/03_cuda.LCK" ]]; then
  echo -e '\nInstalling cuda...\n'
  sudo "$HOME/git/aws-hashcat/scripts/03_cuda.sh"
  echo 'System going down for reboot [3/3]...'
  sudo touch "${dir}/03_cuda.LCK"
  sleep 5
  sudo reboot
fi

echo -e '\nhashcat is ready.\n'

echo -e "\nTo check nvidia status, run 'sudo nvidia-smi'.\n"
