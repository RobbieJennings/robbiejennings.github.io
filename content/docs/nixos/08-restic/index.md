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

## Backing up user files to Google Drive
Using a combination of [Rclone](https://rclone.org) and [Restic](https://restic.net) we can create scheduled, deduplicated backups of user files. This requires a a valid client ID, client secret and access token set up through the google developer console.

## Configuring Rclone
Rclone can be set up using a sops-nix template as such:
{{<codefile
  file="assets/code/nix-config/modules/users/backup/rclone.nix"
  type="nix"
>}}

## Configuring Restic
Restic can be configured using the *services.restic* config option as follows:
{{<codefile
  file="assets/code/nix-config/modules/users/backup/restic.nix"
  type="nix"
>}}
