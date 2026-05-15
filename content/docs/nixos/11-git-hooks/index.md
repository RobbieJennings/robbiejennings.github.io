+++
showDate = false
showAuthor = false
draft = false
title = 'NixOS: Ensuring Correctness with Git Hooks'
series = ["NixOS"]
series_order = 11
weight = 289
tags = ["NixOS"]
categories = ["Development", "Homelab"]
+++

## Adding Nix checks
Using the pre-commit-hooks flake module we can define the set of checks to be run by the *nix check* command:
{{<codefile
  file="assets/code/nix-config/modules/nix/checks.nix"
  type="nix"
>}}

## Adding git hooks to run checks before committing
With the checks defined, we can create a nix dev-shell to install git hooks to run each check before commits:
{{<codefile
  file="assets/code/nix-config/modules/nix/dev-shells.nix"
  type="nix"
>}}