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
  flake.modules.nixos.transmission =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      image = pkgs.dockerTools.pullImage {
        imageName = "linuxserver/transmission";
        imageDigest = "sha256:978b9e0b06eda2cfed79c861fc8ca440b8b29e45dc9dc2522daa67c3818a0d88";
        sha256 = "sha256-uQWuUyhumbEmxTgYzhWtLjg6z+67qQqlRZ2W134ZHbA=";
        finalImageTag = "4.0.6";
        arch = "amd64";
      };
    in
    {
      options = {
        media-server.transmission.enable = lib.mkEnableOption "transmission manifest on k3s";
      };

      config = lib.mkIf (config.media-server.enable && config.media-server.transmission.enable) {
        services.k3s = {
          images = [ image ];
          manifests.transmission.content = [
            {
              apiVersion = "v1";
              kind = "PersistentVolumeClaim";
              metadata = {
                name = "transmission-config";
                namespace = "media";
              };
              spec = {
                accessModes = [ "ReadWriteOnce" ];
                storageClassName = "longhorn";
                resources.requests.storage = "5Gi";
              };
            }
            {
              apiVersion = "v1";
              kind = "PersistentVolumeClaim";
              metadata = {
                name = "transmission-watch";
                namespace = "media";
              };
              spec = {
                accessModes = [ "ReadWriteOnce" ];
                storageClassName = "longhorn";
                resources.requests.storage = "5Gi";
              };
            }
            {
              apiVersion = "apps/v1";
              kind = "Deployment";
              metadata = {
                name = "transmission";
                namespace = "media";
              };
              spec = {
                replicas = 1;
                selector.matchLabels.app = "transmission";
                template = {
                  metadata.labels.app = "transmission";
                  spec = {
                    containers = [
                      {
                        name = "transmission";
                        image = "${image.imageName}:${image.imageTag}";
                        ports = [
                          { containerPort = 9091; }
                          {
                            containerPort = 51413;
                            protocol = "TCP";
                          }
                          {
                            containerPort = 51413;
                            protocol = "UDP";
                          }
                        ];
                        env = [
                          {
                            name = "PUID";
                            value = "1000";
                          }
                          {
                            name = "PGID";
                            value = "1000";
                          }
                        ];
                        resources = {
                          requests.cpu = "50m";
                          requests.memory = "128Mi";
                          limits.cpu = "300m";
                          limits.memory = "256Mi";
                        };
                        startupProbe = {
                          httpGet = {
                            path = "/transmission/web/";
                            port = 9091;
                          };
                          failureThreshold = 30;
                          periodSeconds = 5;
                        };
                        readinessProbe = {
                          httpGet = {
                            path = "/transmission/web/";
                            port = 9091;
                          };
                          initialDelaySeconds = 15;
                          periodSeconds = 10;
                          timeoutSeconds = 2;
                          failureThreshold = 3;
                        };
                        livenessProbe = {
                          httpGet = {
                            path = "/transmission/web/";
                            port = 9091;
                          };
                          initialDelaySeconds = 30;
                          periodSeconds = 20;
                          timeoutSeconds = 2;
                          failureThreshold = 3;
                        };
                        volumeMounts = [
                          {
                            name = "config";
                            mountPath = "/config";
                          }
                          {
                            name = "watch";
                            mountPath = "/watch";
                          }
                          {
                            name = "downloads";
                            mountPath = "/downloads";
                          }
                        ];
                      }
                    ];
                    volumes = [
                      {
                        name = "config";
                        persistentVolumeClaim.claimName = "transmission-config";
                      }
                      {
                        name = "watch";
                        persistentVolumeClaim.claimName = "transmission-watch";
                      }
                      {
                        name = "downloads";
                        persistentVolumeClaim.claimName = "downloads";
                      }
                    ];
                    dnsConfig.options = [
                      {
                        name = "ndots";
                        value = "0";
                      }
                    ];
                  };
                };
              };
            }
            {
              apiVersion = "v1";
              kind = "Service";
              metadata = {
                name = "transmission-lb";
                namespace = "media";
                annotations = {
                  "metallb.io/address-pool" = "default";
                  "metallb.io/allow-shared-ip" = "media";
                };
              };
              spec = {
                type = "LoadBalancer";
                loadBalancerIP = "192.168.1.202";
                selector = {
                  "app" = "transmission";
                };
                ports = [
                  {
                    name = "http";
                    port = 9091;
                    targetPort = 9091;
                  }
                  {
                    name = "peer";
                    port = 51413;
                    targetPort = 51413;
                    protocol = "TCP";
                  }
                  {
                    name = "peer-udp";
                    port = 51413;
                    targetPort = 51413;
                    protocol = "UDP";
                  }
                ];
              };
            }
          ];
        };
      };
    };
}
```