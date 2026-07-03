# monorepo

`monorepo` is a template repository for starting future projects with a shared
development environment and project structure.

## Prerequisites

Before developing in this repository, install:

- [Nix](https://nixos.org/download/)
- [Docker](https://docs.docker.com/get-docker/)

## Usage

Use this prompt with your coding agent to configure the template for a new
project:

```text
Configure this repository for a new project. Rename the project from `monorepo`
to the new project name, update package names, documentation, configuration
files, and references across the repo. Preserve the existing Nix and Docker
development setup unless a change is required for the new project.
```

## Development

This repo includes a Nix flake for the local development toolchain.
Run `nix develop` before working in this repository to enter the required
development shell.

```bash
nix develop
```
