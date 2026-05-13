+++
showDate = false
showAuthor = false
draft = false
title = 'Kubernetes: Adding CloudnativePG Databases'
series = ["Kubernetes"]
series_order = 7
weight = 193
tags = ["Kubernetes"]
categories = ["Development", "Homelab"]
+++

## Deploying postgres databases using CloudnativePG
CloudnativePG provides an easy to use API to deploy postgres databases on our cluster drawing from a single image pool with easy backups and configuration.

## Deploying the cloudnativePG Helm chart and image catalog
Before using the cloudnativePG API we must deploy the official helm chart. We must also define a postgres image catalog for database deployments to use:
{{<codefile
  file="assets/code/nix-config/modules/server/database/postgres.nix"
  type="nix"
>}}

## Deploying postgres databases
Once installed, we can use CloudnativePG to define postgres databases for use in complex service deployments:
{{<codefile
  file="assets/code/nix-config/modules/server/immich/postgres.nix"
  type="nix"
>}}