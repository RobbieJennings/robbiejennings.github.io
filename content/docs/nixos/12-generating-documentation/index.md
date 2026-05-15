+++
showDate = false
showAuthor = false
draft = false
title = 'NixOS: Generating Module Documentation'
series = ["NixOS"]
series_order = 12
weight = 288
tags = ["NixOS"]
categories = ["Development", "Homelab"]
+++

## Generating Markdown documentation for NixOS modules
Using the *nixosOptionsDoc* package we can generate markdown documentation for both nixos and home-manager modules:
{{<codefile
  file="assets/code/nix-config/modules/nix/packages.nix"
  type="nix"
  startLine=21
  endLine=71
>}}