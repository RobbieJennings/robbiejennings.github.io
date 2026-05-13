+++
showDate = false
showAuthor = false
title = 'Kubernetes: Introduction'
series = ["Kubernetes"]
series_order = 1
weight = 199
tags = ["Kubernetes"]
categories = ["Development", "Homelab"]
+++

## Introduction
This documentation follows on from my NixOS documentation and describes the creation of a single node k3s cluster using nix. A mixture of helm and raw manifests will be used but all will be defined in pure nix as part of my [nix-config](https://github.com/robbiejennings/nix-config) flake.

## Enabling k3s
To begin using Kubernetes on NixOS we can enable the k3s service along with a token secret:
{{<codefile
  file="assets/code/nix-config/modules/server/k3s.nix"
  type="nix"
>}}

## Extra Reading
[NixOS Documentation]({{< ref "docs/nixos/01-introduction/index.md" >}})\
[Defining k3s in Pure Nix](https://github.com/rorosen/k3s-nix/tree/main)