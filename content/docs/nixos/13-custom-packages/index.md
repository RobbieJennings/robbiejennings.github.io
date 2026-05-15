+++
showDate = false
showAuthor = false
draft = false
title = 'NixOS: Custom Packages'
series = ["NixOS"]
series_order = 13
weight = 287
tags = ["NixOS"]
categories = ["Development", "Homelab"]
+++

## Writing custom packages
For software that is not included in the official Nix repository we can make use of Nix derivations to package our own applications:
{{<codefile
  file="assets/code/nix-config/packages/vuescan.nix"
  type="nix"
>}}

## Importing derivations
Custom package derivations can be imported into a nix configuration using overlays:
{{<codefile
  file="assets/code/nix-config/modules/nix/packages.nix"
  type="nix"
  startLine=13
  endLine=19
>}}