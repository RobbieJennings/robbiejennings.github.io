+++
showDate = false
showAuthor = false
draft = false
title = 'NixOS: Encrypting Secrets with SOPS'
series = ["NixOS"]
series_order = 6
weight = 294
tags = ["NixOS"]
categories = ["Development", "Homelab"]
+++

## Encrypting secrets
Secrets such as API keys and passwords should never be stored in plain text. Instead, we can use sops-nix to import this sensitive data from encrypted files. This negates the need to omit certain files from public repositories and reduces the risk of leaks due to human error.

## Prerequisites
### Generating age key
In order to encrypt and decrypt secret files, we must first tell sops the location of our age file. This can be generated from an SSH key using the *ssh-to-age* package. In this case, we use separate keys for root and user secrets:
```bash
# Generate user age
mkdir -p ~/.config/sops/age
ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt
# Generate root age
mkdir -p /root/.config/sops/age
ssh-to-age -private-key -i /root/.ssh/id_ed25519 > /root/.config/sops/age/keys.txt
```

### Creating secret files
Once age keys are generated for both root and user secrets, we can use sops to generate secret files. For simple importing, we can reuse our username and hostname config options for these filenames:
```bash
# Create user secrets
sops edit ./secrets/<username>.yaml
# Create root secrets
sops edit ./secrets/<hostname>.yaml
```

## Importing secrets in our nix config
Before using secrets, we must add a configuration module to setup sops-nix for both nixos (root secrets) and home-manager (user-secrets):
{{<codefile
  file="assets/code/nix-config/modules/core/secrets.nix"
  type="nix"
>}}

Then we can import root secrets such as user passwords like:
{{<codefile
  file="assets/code/nix-config/modules/users/desktop-user.nix"
  type="nix"
  startLine=47
  endLine=53
>}}

We can import user secrets such as license keys and create template files like:
{{<codefile
  file="assets/code/nix-config/modules/users/editing/vuescan.nix"
  type="nix"
  startLine=24
  endLine=42
>}}
