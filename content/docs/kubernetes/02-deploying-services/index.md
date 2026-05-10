+++
showDate = false
showAuthor = false
draft = false
title = 'Kubernetes: Deploying Services'
series = ["Kubernetes"]
series_order = 2
weight = 198
tags = ["Kubernetes"]
categories = ["Development", "Homelab"]
+++

## Deploying Helm Charts
To install a Helm chart on NixOS we can use the *services.k3s.autoDeployCharts.\<chart>* config value to define the chart to be imported, the namespace it is to be deployed to as well as the values to be passed to the chart. Images can also be preloaded using *services.k3s.images* config value. This can be done like:
```nix
{
  inputs,
  ...
}:
{
  flake.modules.nixos.grafana =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "grafana";
        repo = "https://grafana-community.github.io/helm-charts";
        version = "11.1.7";
        hash = "sha256-KSHxBROOLZeaf7CeqFm6mStp58AnRgQaclWRHyJL/FU=";
      };
      image = pkgs.dockerTools.pullImage {
        imageName = "grafana/grafana";
        imageDigest = "sha256:62a54c76afbeea0b8523b7afcd9e7ee1f0e39806035fd90ffc333a19e9358f2f";
        sha256 = "sha256-OhTmnRsqpgJbNxOD4zNUehEaX2l28HNxKJ9Nec2XLfs=";
        finalImageTag = "12.3.3";
        arch = "amd64";
      };
    in
    {
      options = {
        monitoring.grafana.enable = lib.mkEnableOption "prometheus service on k3s";
        secrets.grafana.enable = lib.mkEnableOption "grafana secrets";
      };

      config = lib.mkIf config.monitoring.grafana.enable {
        services.k3s = {
          images = [ image ];
          autoDeployCharts.grafana = chart // {
            targetNamespace = "monitoring";
            createNamespace = true;
            values = {
              replicas = 1;
              image = {
                repository = image.imageName;
                tag = image.imageTag;
              };
              adminUser = "admin";
              adminPassword = "changeme";
              admin =
                if (config.secrets.enable && config.secrets.grafana.enable) then
                  {
                    existingSecret = "grafana-secrets";
                  }
                else
                  { };
              persistence = {
                enabled = true;
                storageClassName = "longhorn";
                size = "10Gi";
              };
              service.enable = false;
              resources = {
                requests.cpu = "50m";
                requests.memory = "128Mi";
                limits.cpu = "300m";
                limits.memory = "256Mi";
              };
              datasources = {
                "datasources.yaml" = {
                  apiVersion = 1;
                  datasources = [
                    {
                      name = "Prometheus";
                      type = "prometheus";
                      access = "proxy";
                      url = "http://192.168.1.210:9090";
                      isDefault = true;
                      editable = false;
                    }
                    {
                      name = "Loki";
                      type = "loki";
                      access = "proxy";
                      url = "http://192.168.1.210:3100";
                      editable = false;
                    }
                  ];
                };
              };
            };
            extraDeploy = [
              {
                apiVersion = "v1";
                kind = "Service";
                metadata = {
                  name = "grafana-lb";
                  namespace = "monitoring";
                  annotations = {
                    "metallb.io/address-pool" = "default";
                    "metallb.io/allow-shared-ip" = "monitoring";
                  };
                };
                spec = {
                  type = "LoadBalancer";
                  loadBalancerIP = "192.168.1.210";
                  selector = {
                    "app.kubernetes.io/name" = "grafana";
                    "app.kubernetes.io/instance" = "grafana";
                  };
                  ports = [
                    {
                      name = "http";
                      port = 3000;
                      targetPort = 3000;
                    }
                  ];
                };
              }
            ];
          };
        };
      }
    };
}
```

## Deploying Raw Manifests
To install a service using raw manifests on NixOS we can use the *services.k3s.manifests.\<service-name>* config value to define the manifests to be deployed. Images can also be preloaded using *services.k3s.images* config value. This can be done like:
```nix
{
  inputs,
  ...
}:
{
  flake.modules.nixos.metallb =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "metallb";
        repo = "https://metallb.github.io/metallb";
        version = "0.15.2";
        hash = "sha256-Tw/DE82XgZoceP/wo4nf4cn5i8SQ8z9SExdHXfHXuHM=";
      };
      controllerImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/metallb/controller";
        imageDigest = "sha256:417cdb6d6f9f2c410cceb84047d3a4da3bfb78b5ddfa30f4cf35ea5c667e8c2e";
        sha256 = "sha256-AzOCFyOAeLsFw7ESAg8iYygzH4ygxgNQcJ5rpajbnio=";
        finalImageTag = "v0.15.2";
        arch = "amd64";
      };
      speakerImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/metallb/speaker";
        imageDigest = "sha256:260c9406f957c0830d4e6cd2e9ac8c05e51ac959dd2462c4c2269ac43076665a";
        sha256 = "sha256-gdy9zFJjY9wTYKuF7j5NW16V6oPWdFwEji+Nvt5Qr7Y=";
        finalImageTag = "v0.15.2";
        arch = "amd64";
      };
    in
    {
      options = {
        metallb.enable = lib.mkEnableOption "metalLB helm chart on k3s";
      };

      config = lib.mkIf config.metallb.enable {
        services.k3s = {
          images = [
            controllerImage
            speakerImage
          ];
          autoDeployCharts.metallb = chart // {
            targetNamespace = "metallb-system";
            createNamespace = true;
            values = {
              controller.image = {
                repository = controllerImage.imageName;
                tag = controllerImage.imageTag;
              };
              speaker.image = {
                repository = speakerImage.imageName;
                tag = speakerImage.imageTag;
              };
            };
            extraDeploy = [
              {
                apiVersion = "metallb.io/v1beta1";
                kind = "IPAddressPool";
                metadata = {
                  name = "default";
                  namespace = "metallb-system";
                };
                spec = {
                  addresses = [ "192.168.1.200-192.168.1.210" ];
                  autoAssign = true;
                };
              }
              {
                apiVersion = "metallb.io/v1beta1";
                kind = "L2Advertisement";
                metadata = {
                  name = "default";
                  namespace = "metallb-system";
                };
                spec = {
                  ipAddressPools = [ "default" ];
                };
              }
            ];
          };
        };
      };
    };
}
```