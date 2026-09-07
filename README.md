# monorepo

`monorepo` is a template repository for starting future projects with a shared
development environment and project structure.

See [CONTRIBUTING.md](./CONTRIBUTING.md) for the development workflow,
verification commands, workspace conventions, and commit guidelines.

## Prerequisites

Before developing in this repository, install:

- [Node.js 24](https://nodejs.org/en/download)
- [pnpm 12.3.4](https://pnpm.io/installation)
- [Docker](https://docs.docker.com/get-docker/)

## Usage

Use this prompt with your coding agent to configure the template for a new
project:

```text
Configure this repository for a new project. Rename the project from `monorepo`
to the new project name, update package names, documentation, configuration
files, and references across the repo. Preserve the existing Node.js, pnpm, and
Docker development setup unless a change is required for the new project.
```

## Development

Install dependencies with the versions declared in `package.json`:

```bash
pnpm install
```
