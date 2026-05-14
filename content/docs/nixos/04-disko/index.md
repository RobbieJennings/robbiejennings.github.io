+++
showDate = false
showAuthor = false
draft = false
title = 'NixOS: Partitioning Drives with Disko'
series = ["NixOS"]
series_order = 4
weight = 296
tags = ["NixOS"]
categories = ["Development", "Homelab"]
+++

## Importing the Disko module
Before installing NixOS, it is important that all drives are correctly formatted and mounted. This can be done declaratively by importing the [Disko](https://github.com/nix-community/disko) module flake.

## Defining disk partitions
Disk partitions can be defined using the *disko.devices* configuration option. An example of a BTRFS boot drive declaration including LUKS encryption and dedicated persistence sub-partition looks like:
{{<codefile
  file="assets/code/nix-config/modules/hosts/xps15/disk-configuration.nix"
  type="nix"
>}}

## Partitioning disks
Prior to installing NixOS, we can partition disks like:
```bash
sudo nix run --experimental-features "nix-command flakes" github:nix-community/disko/latest -- --mode destroy,format,mount --flake github:robbiejennings/nix-config#<system>
```