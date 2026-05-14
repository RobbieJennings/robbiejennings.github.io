+++
showDate = false
showAuthor = false
draft = false
title = 'NixOS: Ephemeral Root with Impermanence'
series = ["NixOS"]
series_order = 5
weight = 295
tags = ["NixOS"]
categories = ["Development", "Homelab"]
+++

## Importing the Impermanence module
As we use Nix to define our system state, the only directories actually required for boot are */boot* and */nix*. We can leverage this to ensure only desired files are actually retained on boot, eliminating cruft and ensuring pristine state upon each  reboot. This can be done declaratively by importing the [Impermanence](https://github.com/nix-community/impermanence) module flake.

## Destroying root
Using our BTRFS volume defined in the previous section, we can add an initrd service to delete the entire */root* sub-partition on boot. Nix will then regenerate all required files with symlinks to the nix store located in the separate */nix* sub-partition.
{{<codefile
  file="assets/code/nix-config/modules/core/impermanence.nix"
  type="nix"
>}}

## Persisting files
Using the *environment.persistence.\<persistence sub-partition>* configuration option we can set desired system directories such as bluetooth and network settings to be mounted to the persisted sub-partition and symlinked to their actual location in the root sub-partition:
{{<codefile
  file="assets/code/nix-config/modules/systems/laptop.nix"
  type="nix"
  startLine=53
  endLine=67
>}}

Similarly, we can persist user files such as Desktop, Documents and Flatpak applications:
{{<codefile
  file="assets/code/nix-config/modules/users/desktop-user.nix"
  type="nix"
  startLine=55
  endLine=93
>}}
