+++
showDate = false
showAuthor = false
draft = false
title = 'NixOS: Theming with Stylix'
series = ["NixOS"]
series_order = 7
weight = 293
tags = ["NixOS"]
categories = ["Development", "Homelab"]
+++

## Adding options for colour schemes, fonts and wallpapers
Using [Stylix](https://github.com/nix-community/stylix), we can apply [base16 colour schemes](https://tinted-theming.github.io/tinted-gallery), wallpapers and fonts. Separate modules should be instantiated for nixos for system theming and home-manager for user theming. The options and contents for each of these modules can be identical:
{{<codefile
  file="assets/code/nix-config/modules/core/theme.nix"
  type="nix"
>}}

## Setting theme options in our config
With the theme modules loaded we can configure themes for each system and user:
{{<codefile
  file="assets/code/nix-config/modules/systems/laptop.nix"
  type="nix"
  startLine=22
  endLine=28
>}}
