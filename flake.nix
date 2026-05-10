{
  description = "A Nix flake for a HUGO devshell, package and Docker image";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-config = {
      url = "github:robbiejennings/nix-config";
      flake = false;
    };
    blowfish = {
      url = "github:nunocoracao/blowfish";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, nix-config, blowfish }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "x86_64-darwin"
        "i686-linux"
        "aarch64-linux"
      ];
      pkgs = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (system: {
        default = pkgs.${system}.stdenv.mkDerivation {
          pname = "blog";
          version = "0.1.0";
          src = ./.;
          dontConfigure = true;
          buildPhase = ''
            mkdir -p themes/blowfish
            mkdir -p assets/code/nix-config
            cp -r --no-preserve=mode ${blowfish}/* themes/blowfish
            cp -r --no-preserve=mode ${nix-config}/* assets/code/nix-config
            ${pkgs.${system}.hugo}/bin/hugo
          '';
          installPhase = "cp -r public $out";
        };

        dockerImage = pkgs.${system}.dockerTools.buildImage {
          name = "blog";
          tag = "latest";
          copyToRoot = pkgs.${system}.buildEnv {
            name = "image-root";
            paths = [ self.packages.${system}.default pkgs.${system}.caddy ];
            pathsToLink = [ "/public" ];
          };
          config = {
            Cmd = [ "${pkgs.${system}.caddy}/bin/caddy" "file-server" "--root" "${self.packages.${system}.default}" "--listen" ":8080" ];
            ExposedPorts = {
              "8080/tcp" = { };
            };
          };
        };
     });

      devShells = forAllSystems (system: {
        default = pkgs.${system}.mkShell {
          buildInputs = with pkgs.${system}; [
            hugo
            git
          ];
          shellHook = ''
            rm -rf themes/blowfish
            rm -rf assets/code/nix-config
            mkdir -p themes/blowfish
            mkdir -p assets/code/nix-config
            cp -r --no-preserve=mode ${blowfish}/* themes/blowfish
            cp -r --no-preserve=mode ${nix-config}/* assets/code/nix-config
            hugo server
          '';
        };
      });
    };
}
