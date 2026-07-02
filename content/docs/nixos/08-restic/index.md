+++
showDate = false
showAuthor = false
draft = false
title = 'NixOS: Backing Up with Restic'
series = ["NixOS"]
series_order = 8
weight = 292
tags = ["NixOS"]
categories = ["Development", "Homelab"]
+++

## Backing up user files via Restic
Using an S3 bucket we can store dedeuplicated backups with Restic.

## Configuring Restic
Restic can be configured using the *services.restic* config option as follows:
{{<codefile
  file="assets/code/nix-config/modules/users/backup/restic.nix"
  type="nix"
>}}
