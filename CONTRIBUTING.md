# Contributing

This repository is a template monorepo. Keep changes small, explicit, and easy
to carry forward into future projects created from the template.

## Prerequisites

Install these before working in the repo:

- [Node.js 24](https://nodejs.org/en/download)
- [pnpm 12.3.4](https://pnpm.io/installation)
- [Docker](https://docs.docker.com/get-docker/)

## Development Setup

Install dependencies:

```bash
pnpm install --frozen-lockfile
```

The private `@adamaho` dependencies require GitHub Packages authentication.
Export `NODE_AUTH_TOKEN` with a classic personal access token that has
`read:packages`, then reference the environment variable from a user npm config:

```ini
//npm.pkg.github.com/:_authToken=${NODE_AUTH_TOKEN}
```

Do not commit a token. CI and `.agents/setup` create and remove a temporary user
config automatically.

Start local infrastructure when a package needs shared runtime services:

```bash
pnpm --filter=@monorepo/infra-local run infra:up
```

## Verification

Run the full local verification command before opening a PR or committing a
completed change:

```bash
pnpm check
```

This runs the repository format check first, then lets Turbo run package-level
lint and TypeScript tasks in parallel where packages define them.

Useful focused commands:

- `pnpm fmt` formats the repository
- `pnpm fmt:check` checks formatting without writing changes
- `pnpm lint` runs package lint tasks through Turbo
- `pnpm turbo run test:unit` runs package unit test tasks through Turbo
- `pnpm tsc` runs package TypeScript tasks through Turbo

## Workspace Layout

Use the existing top-level workspace directories consistently:

- `programs/*` for deployable applications, APIs, workers, and other executables
- `packages/*` for shared features, reusable libraries, and external service clients
- `tools/*` for internal tooling packages
- `infra/*` for local and shared infrastructure helpers

Programs are deployable entry points and should stay thin.
Keep code used by only one deployable local to it, such as under
`programs/web/src/features/*`. Move a feature or capability into `packages/*`
when it becomes shared or needs an explicit public API and dependency boundary.

Do not apply category-based prefixes or suffixes to packages under `packages/*`.
The directory name must match the package's `package.json` name, excluding the
npm scope when present. For example, `packages/billing/package.json` uses the
name `@monorepo/billing`.

## Dependency Management

Prefer centralizing shared dependency versions in `pnpm-workspace.yaml` using
the catalog. This keeps package manifests small and makes upgrades easier to
review.

Use exact versions. The root `.npmrc` sets `save-exact=true` and
`engine-strict=true`.

pnpm applies the `minimumReleaseAge` policy in `pnpm-workspace.yaml` to direct
and transitive dependencies and re-verifies the committed lockfile during
installation. The policy is strict and fails closed unless a release is at
least 24 hours old. This delay gives registries and security scanners time to
remove compromised releases without making routine dependency work onerous.

The private first-party `@adamaho` packages currently consumed by the template
are excluded by exact package name so their deliberate releases can be tested
immediately. Do not broaden these entries to the whole scope. For an urgent
third-party update, add a version-specific exclusion such as `package@1.2.3`,
explain it in the pull request, and remove it after the release is 24 hours old.
pnpm automatically prunes exclusions that no longer resolve in the lockfile.

The `gh:` catalog specifiers bind private dependencies to GitHub Packages in
the lockfile. Keep that registry qualification when updating them. Template
consumers must remove or replace the `@adamaho` authentication, specifiers, and
age exceptions if they stop consuming these packages or move them to another
registry.

When upgrading pnpm, keep the exact version aligned in `packageManager`, the
pnpm engine, `.agents/setup`, and the prerequisite documentation. Refresh the
`packageManager` SHA-512 hash from the published package integrity, then
regenerate and commit the lockfile with that exact pnpm release. CI reads the
version from `packageManager` and requires the committed lockfile.

## Changesets

Add a changeset when a pull request changes the public behavior of a publishable
package:

```bash
pnpm changeset
```

Select every affected package, choose the appropriate semantic version bump,
and commit the generated `.changeset/*.md` file with the change.

A changeset is not required for documentation, infrastructure,
application-only, or private-package changes. Run `pnpm changeset:status` to
inspect pending releases.

## Documentation Comments

Use JSDoc when it helps consumers understand an exported API. Use comments for
non-obvious behavior, invariants, side effects, failure semantics, lifecycle
requirements, intent, and tradeoffs.

Private helpers with clear names and TypeScript types do not require JSDoc. Do
not add `@param` or `@returns` tags when they merely repeat names and types
already expressed by TypeScript. Tests, fixtures, and straightforward
transformations generally do not need JSDoc.

Comments should explain why, not restate what the code does.

## Commit Messages

Prefer using the configured coding agent commit workflow when creating commits.
The agent formats the repo, stages the intended changes, writes a compliant
commit message, and pushes to the current branch.

Commit subjects must use scoped Conventional Commit format:

```text
<type>(<scope>): <description>
```

Allowed types:

- `feat`
- `fix`
- `docs`
- `chore`
- `refactor`
- `test`

Use the affected package name without the npm scope as the commit scope. For
root-only template changes, use `monorepo`.

Examples:

```text
chore(monorepo): add contributor documentation
feat(web): add account settings page
fix(api): validate missing request body
```

## Coding Agents

Coding agents should use the Node.js and pnpm versions declared in
`package.json`. Verify their versions before running project commands:

```bash
node --version
pnpm --version
```
