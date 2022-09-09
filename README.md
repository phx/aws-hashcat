# aws-hashcat

This is a quickstart process to install all the necessary GPU drivers and options for `hashcat` on Ubuntu 20.04 and 22.04 AWS instances.

The following may not be an exhaustive list, but I know that the following instance types are compatible:

- g4dn.xlarge ($0.53 per hour)
- g3s.xlarge ($0.75 per hour)
- p3.16xlarge ($24.48 per hour - watch out for this guy, he's expensive)

The `p3.16xlarge` requires a [service limit increase](https://console.aws.amazon.com/support/home?#/case/create) for your account, and availability can actually be limited at times, depending on region, so you may have to keep trying to launch
the instance every few minutes or so until it is successful.  You want to be careful running this type of instance.  It is *NOT* for long-term use.

These types of instances are meant to be spun up when you need some decent GPU power for cracking hashes, and you should terminate them as soon as you are done in order to avoid large fees, especially the `p3.16xlarge`.

The full set of installed packages takes around 15GB of space to install. After install around 3GB can be freed with `apt clean all`. It's recommended to use a root disk of at least 16GB on your instances.

## Installation

```
git clone https://github.com/phx/aws-hashcat
cd aws-hashcat
./install.sh
```

## Installation flow

Your instance will reboot 3 times:

- 1: after running `./install.sh`
- 2: after logging in via `ssh` a second time
- 3: after logging in via `ssh` a third time

When logging in the 4th time, you will be ready to run `hashcat`, which will already be installed with all necessary GPU drivers.

### Please note:

This repo does not come with any pre-installed wordlists or rules.

I may add a script to download some rules and wordlists, as well as a helper script at some point in the future,
but for now this remains BYOA (Bring Your Own Assets).

Right now, this repo is simply used to help make the best use of your time while setting up a hashcat-ready AWS instance so you can get to cracking ASAP. 

