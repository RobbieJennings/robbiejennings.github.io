+++
showDate = false
showAuthor = false
draft = false
title = 'Kubernetes: A Factory for Valkey'
series = ["Kubernetes"]
series_order = 8
weight = 192
tags = ["Kubernetes"]
categories = ["Development", "Homelab"]
+++

## Using Valkey for cache
As the official Valkey operator for Kubernetes is still in its early development stages at the time of writing, the next best way we can generalise the deployment of Valkey is to create a factory module which deploys the official Valkey Helm chart. This can then be used across multiple service modules.

## Creating the factory module
Using the dendritic pattern, we can easily create a NixOS factory module to handle the deployment of the Valkey helm chart:
>[!NOTE]
>See [NixOS Documentation]({{< ref "docs/nixos/03-dendritic-pattern/index.md" >}}) for more information

{{<codefile
  file="assets/code/nix-config/modules/server/database/valkey.nix"
  type="nix"
>}}

## Deploying valkey caches
Using the valkey factory method we can add individual deployments for use in complex service deployments:
{{<codefile
  file="assets/code/nix-config/modules/server/immich/valkey.nix"
  type="nix"
>}}