+++
showDate = false
showAuthor = false
draft = false
title = 'NixOS: Automatic Updates'
series = ["NixOS"]
series_order = 10
weight = 290
tags = ["NixOS"]
categories = ["Development", "Homelab"]
+++

## Updating flake.lock using Github Actions
Using [Determinate Systems nix-installer](https://github.com/DeterminateSystems/update-flake-lock) github action we can create a scheduled task to update the flake and merge the changes into our main branch:
{{<codefile
  file="assets/code/nix-config/.github/workflows/update-flake-lock.yml"
  type="yaml"
>}}

## Updating system from remote repo
We can use the *system.autoUpgrade* configuration option to keep the system installation up to date with the main branch:
{{<codefile
  file="assets/code/nix-config/modules/core/auto-upgrade.nix"
  type="nix"
>}}