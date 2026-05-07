# List all the just commands
# Usage: $ just
default:
  @just --list

# Build the blog
build:
  nix build

# Build the docker image
build-docker:
  nix build .#dockerImage

# Run the blog
run:
  nix develop

# Run the docker image
run-docker:
  just build-docker
  docker load < result
  rm -rf result
  docker run -p 8080:8080 blog:latest
