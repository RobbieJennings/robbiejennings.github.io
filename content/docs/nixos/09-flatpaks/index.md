+++
showDate = false
showAuthor = false
draft = false
title = 'NixOS: Installing Flatpaks'
series = ["NixOS"]
series_order = 9
weight = 291
tags = ["NixOS"]
categories = ["Development", "Homelab"]
+++

## Installing Flatpak applications
Using the [nix-flatpak](https://github.com/gmodena/nix-flatpak) home-manager module we can install Flatpak applications declaratively. This ensures that including applications are installed upon each rebuild:
{{<codefile
  file="assets/code/nix-config/modules/users/web/firefox.nix"
  type="nix"
>}}
