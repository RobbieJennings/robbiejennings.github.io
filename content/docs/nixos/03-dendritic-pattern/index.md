+++
showDate = false
showAuthor = false
draft = false
title = 'NixOS: The Dendritic Pattern'
series = ["NixOS"]
series_order = 3
weight = 297
tags = ["NixOS"]
categories = ["Development", "Homelab"]
+++

## Introduction
The [Dendritic Pattern](https://github.com/mightyiam/dendritic) is a simple, yet powerful approach to defining complex Nix projects containing a mix of nixos and home-manager modules without the need for spaghetti code or complex wiring functions. This is accomplished using the [Flake Parts](https://flake.parts) module to define every aspect as a top level function, all of which may be merged at evaluation time. Each module can be imported at the flake level using the handy [Import-Tree](https://github.com/denful/import-tree) module.

## Defining a dendritic flake
The flake.nix of a dendritic nixos configuration should contain only three elements:
 - A description of the flake
 - A list of imports for the flake
 - A single output making use of the flake parts mkFlake function

A simple flake to create a nixos-configuration with modules defined in the *modules* subdirectory looks like:
```nix
{
  description = "Robbie's NixOS flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.11";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
```

## Defining a module for basic settings
A single module can be defined for re-used nix and home-manager settings to reduce code duplication across configurations:
{{< codefile file="assets/code/nix-config/modules/nix/settings.nix" lang="nix" >}}

## Defining a feature module
Though modules are composable, each module file should handle a single repsonsibility. For example, a desktop module may contain many individual feature modules to cover the desktop environments, audio interfaces, etc...\

### Single feature
An "audio" module may look like:
{{< codefile file="assets/code/nix-config/modules/desktop/audio.nix" lang="nix" >}}

### Multi-feature
This may be imported into a high-level "desktop" module like:
{{< codefile file="assets/code/nix-config/modules/desktop/default.nix" lang="nix" >}}

## The factory method
Adding a named "factory" flake module with an unspecified attribute list as its type will allow for the creation of factory modules. These modules look similar to typical nixos or home-manager modules with the exception that they take an addtional attribute set as the initial argument and can then be re-used to instantiate multiple modules using the same logic.

The factory module should look like:
{{< codefile file="assets/code/nix-config/modules/nix/factory.nix" lang="nix" >}}

This flake module can then be used to instantiate a desktop-user nixos module like:
{{< codefile file="assets/code/nix-config/modules/users/desktop-user.nix" lang="nix" >}}

## Creating a system configuration
Bringing everything together, we can create a complete NixOS system configuration using the flake.nixosConfigurations.\<hostname> function. A laptop system module may look like:
{{< codefile file="assets/code/nix-config/modules/systems/laptop.nix" lang="nix" >}}
