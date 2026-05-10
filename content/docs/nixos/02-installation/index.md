+++
showDate = false
showAuthor = false
draft = false
title = 'NixOS: Installation'
series = ["NixOS"]
series_order = 2
weight = 298
tags = ["NixOS"]
categories = ["Development", "Homelab"]
+++

## Installation
### Provision Disks using Disko
Disks must first be prepared for installation. Thankfully, this can be fully automated in Nix using the handy [Disko](https://github.com/nix-community/disko) tool. Be careful to take full backups as all data on the host will be erased upon formatting. If installing a system with LUKS encryption, you will be prompted to add a secure password.

```bash
# Provision disks
sudo nix run --experimental-features "nix-command flakes" github:nix-community/disko/latest -- --mode destroy,format,mount --flake github:robbiejennings/nix-config#<system>
```

### Install a NixOS system
Once disko is finished formatting disks and initialising the required filesystems we can move onto the NixOS installation. Again, this is a simple one-line command where you will be asked for a secure root password. 

```bash
# Install NixOS
sudo nixos-install --flake github:robbiejennings/nix-config#<system>
```
