+++
showDate = false
showAuthor = false
draft = false
title = 'Kubernetes: Longhorn Persistence'
series = ["Kubernetes"]
series_order = 4
weight = 196
tags = ["Kubernetes"]
categories = ["Development", "Homelab"]
+++

## Using Longhorn for cloud native persistent volumes
Longhorn provides cloud native, persistent volume provisioning with replication and easy backups. Perfect for a homelab, it can be easily deployed to our k3s cluster using the official Helm chart.

## Deploying Longhorn
### Helm chart
First, we add modules to import the chart and set the namespace:
>[!NOTE]
>The namespace must be set to longhorn-system for the deployment to work

{{<codefile
  file="assets/code/nix-config/modules/server/longhorn/charts.nix"
  type="nix"
>}}

### Images
Then we preload each image used by the Helm chart:
{{<codefile
  file="assets/code/nix-config/modules/server/longhorn/images.nix"
  type="nix"
>}}

### Configuring Longhorn for a single node configuration
As Longhorn defaults to a Highly Available configuration with three replicas of each service and persistent volume we must add a module to properly set each replication count to one. Additionally, we must update the reclaim policy so that volumes are not recreated upon system reboots and lower the minimum required storage required to 10% to make the most out of limited system storage:
{{<codefile
  file="assets/code/nix-config/modules/server/longhorn/settings.nix"
  type="nix"
>}}

## Adding persistent volume claims
Once Longhorn is deployed, it should automatically be set as the default storage class in k3s. This means persistent volumes can be defined in manifests as such:
{{<codefile
  file="assets/code/nix-config/modules/server/immich/persistence.nix"
  type="nix"
>}}

## Accessing the dashboard
Longhorn provides and easy to use web frontend. Read the following sections on MetalLB and the Netbird Operator to see how to expose this service to the local network and private vpn respectively.
{{<figure 
  src="longhorn-dashboard.png" 
  alt="Longhorn Dashboard" 
>}}