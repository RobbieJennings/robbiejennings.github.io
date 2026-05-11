+++
showDate = false
showAuthor = false
title = 'Kubernetes: Netbird Operator'
series = ["Kubernetes"]
series_order = 3
weight = 197
tags = ["Kubernetes"]
categories = ["Development", "Homelab"]
+++

## Accessing the Cluster Remotely with Netbird
To access the cluster from outside of the home network we can deploy the Netbird operator for Kubernetes. Similar to tailscale, this allows us to access all of our services through a private mesh network. The operator handles the creation of network router nodes to create secure Wireguard tunnels to our exposed services.

## Prerequisites
Using the Netbird dashboard, a DNS zone, named "homelab" in this case, must be creted along with a srevice user api key with admin permissions.

## Installation
### Helm
We can use the official Helm chart to install the Netbird Operator:
{{<codefile
  file="assets/code/nix-config/modules/server/netbird-operator/charts.nix"
  type="nix"
>}}

### Preloading the Operator and Router Images
The images can be preloaded as usual with their corresponding helm values set:
{{<codefile
  file="assets/code/nix-config/modules/server/netbird-operator/images.nix"
  type="nix"
>}}

### Configuring the Network Router
Using the *netbird.io* api we can deploy our network routers:
{{<codefile
  file="assets/code/nix-config/modules/server/netbird-operator/router.nix"
  type="nix"
>}}

### Adding the Netbird Secret
Using sops-nix we can add a separate manifest to deploy the required Kubernetes secrets:
{{<codefile
  file="assets/code/nix-config/modules/server/netbird-operator/secrets.nix"
  type="nix"
>}}

## Exposing Services
Once installed, we can deploy *NetworkResource* manifests to expose Kubernetes services:
{{<codefile
  file="assets/code/nix-config/modules/server/immich/services.nix"
  type="nix"
>}}

## Managing the Cluster Network in Netbird
With our services deployed, we can manage the generate resources in the "homelab" network on the Netbird dashboard:
{{<figure 
  src="netbird-dashboard.png" 
  alt="Netbird Dashboard" 
>}}