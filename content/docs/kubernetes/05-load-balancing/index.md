+++
showDate = false
showAuthor = false
draft = false
title = 'Kubernetes: MetalLB Load Balancing'
series = ["Kubernetes"]
series_order = 5
weight = 195
tags = ["Kubernetes"]
categories = ["Development", "Homelab"]
+++

## Using MetalLB to expose services on the local network
MetalLB provides bare-metal load balancing which we can use to expose services on our cluster to IP addresses on our local network. It is of course important that the addresses used by MetalLB are not already in use by your 

## Deploying MetalLB
### Helm chart
First, we add modules to import the chart and set the namespace:
>[!NOTE]
>The namespace must be set to metallb-system for the deployment to work

{{<codefile
  file="assets/code/nix-config/modules/server/metallb/charts.nix"
  type="nix"
>}}

### Images
Then we preload each image used by the Helm chart:
{{<codefile
  file="assets/code/nix-config/modules/server/metallb/images.nix"
  type="nix"
>}}

### Adding a default address pool and L2 advertisement
For MetalLB to work we must configure a pool of available IP Addresses and an L2 advertisement:
{{<codefile
  file="assets/code/nix-config/modules/server/metallb/settings.nix"
  type="nix"
>}}

## Exposing Services
Once deployed, services can be exposed using The LoadBalancer service type in Kubernetes manifests:
{{<codefile
  file="assets/code/nix-config/modules/server/media/flaresolverr/services.nix"
  type="nix"
>}}