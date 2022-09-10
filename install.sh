#!/bin/bash

dir='/etc/awshashcat'
# The first run will be manual, the rest automatic as root.
if [[ $UID -eq 0 ]] && [[ ! -f $dir/00_install.LCK ]]; then
  echo 'Please run this script without sudo as a non-root user.'
  exit 1
fi

WARN=0
if [[ -z $(which lsb_release) ]]; then
  echo "lsb_release missing, this is not a target distribution."
  WARN=1
else
  RELEASE=$(lsb_release -r | awk '{print $2}')
  if [[ $RELEASE != '20.04' ]] && [[ $RELEASE != '22.04' ]]; then
    echo "Release $RELEASE is not 20.04 or 22.04."
    WARN=1
  fi
fi

if [[ $WARN -eq 1 ]]; then
  echo ">>> WARNING -- WARNING -- WARNING <<<"
  echo "Supported distributions are Ubuntu 20.04 and 22.04"
  echo "Continuing anyway, but this will probably fail."
  echo ""
fi

cd $(cd -P -- "$(dirname -- "$0")" && pwd -P)
scriptdir="$PWD"

echo -e '\nChecking hashcat readiness...'
sudo mkdir -p "$dir"

# STAGE 1/3
if [[ ! -f "${dir}/00_install.LCK" ]]; then
  sudo bash -c 'echo "#!/bin/bash" >/etc/rc.local'
  sudo bash -c "echo -e \"\n${scriptdir}/install.sh  # HASHCAT INSTALL SCRIPT\" >> /etc/rc.local"
  sudo chmod +x /etc/rc.local
  sudo cp rc-local.service /etc/systemd/system/rc-local.service
  sudo systemctl enable rc-local
  sudo apt update -y
  sudo apt dist-upgrade -y
  echo '
System will go down for 3 reboots during the upgrade/installation process.
After the third reboot your system will be ready to use.

System going down for reboot [1/3]...
'
  sudo touch "${dir}/00_install.LCK"
  sleep 5
  sudo reboot
fi

# STAGE 2/3
if [[ ! -f "${dir}/01_drivers.LCK" ]]; then
  sudo "${scriptdir}/scripts/01_drivers.sh"
  touch "${dir}/01_drivers.LCK"
  sleep 5
  reboot
fi

# STAGE 3/3
if [[ ! -f "${dir}/02_cuda.LCK" ]]; then
  sudo "${scriptdir}/scripts/02_cuda.sh"
  touch "${dir}/02_cuda.LCK"
  sleep 5
  reboot
fi

sed -i '/# HASHCAT INSTALL SCRIPT/d' /etc/rc.local

echo "echo -e 'hashcat is ready.\n'" >>/etc/profile.d/hashcat.sh

echo "echo -e \"To check nvidia status, run 'sudo nvidia-smi'.\n\"" >>/etc/profile.d/hashcat.sh

