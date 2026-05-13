+++
showDate = false
showAuthor = false
draft = false
title = 'Kubernetes: Adding Secrets'
series = ["Kubernetes"]
series_order = 3
weight = 197
tags = ["Kubernetes"]
categories = ["Development", "Homelab"]
+++

## Adding Secrets
We can make use of sops-nix templates to deploy Kubernetes secrets which can then be referenced by Helm charts and other manifests. This should be done for all sensitive data such as API keys and passwords:
{{<codefile
  file="assets/code/nix-config/modules/server/immich/secrets.nix"
  type="nix"
>}}