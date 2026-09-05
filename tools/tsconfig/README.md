# @monorepo/tool-tsconfig

Shared TypeScript configurations for this Turborepo.

## Exports

- `@monorepo/tool-tsconfig/base`: strict baseline compiler defaults.
- `@monorepo/tool-tsconfig/service`: NodeNext service defaults for backend workspaces.
- `@monorepo/tool-tsconfig/app-vite`: bundler and React defaults for Vite workspaces.
- `@monorepo/tool-tsconfig/effect`: optional Effect compiler diagnostics.

## Usage in a workspace package

1. Add this package to the workspace's `devDependencies`:

```json
{
  "devDependencies": {
    "@monorepo/tool-tsconfig": "workspace:*"
  }
}
```

2. Extend the workspace `tsconfig.json`:

```json
{
  "extends": "@monorepo/tool-tsconfig/service",
  "compilerOptions": {
    "outDir": "dist",
    "rootDir": "src"
  },
  "include": ["src/**/*.ts"]
}
```

## Optional Effect support

The default template uses general Nopeus rules and ordinary TypeScript. No
Effect runtime, language server, compiler patch, or Effect test adapter is
installed.

For an Effect project, switch that workspace's Oxlint config to the Effect
preset, which already includes the general plugin rules:

```ts
import base from "@adamaho/nopeus-oxlint-config";
import effect from "@adamaho/nopeus-oxlint-plugin/effect";
import { defineConfig } from "oxlint";

export default defineConfig({
  extends: [base, effect({ packageName: "monorepo" })],
});
```

Use the actual root package name after renaming the template. Runnable programs
also set `runtimeEntryPoints` to their real entry files. These syntax rules need
no compiler patch.

To also enable official Effect compiler diagnostics:

1. Add `"@effect/tsgo": 0.41.0` to the workspace catalog, keeping the existing
   `typescript: 7.0.2` pairing.
2. Add `"@effect/tsgo": "catalog:"` to this tool package's devDependencies and
   `"prepare": "effect-tsgo patch"` to its scripts, retaining other preparation
   commands if present.
3. Opt Effect workspaces into the overlay:

```json
{
  "extends": ["@monorepo/tool-tsconfig/service", "@monorepo/tool-tsconfig/effect"],
  "include": ["src/**/*.ts"]
}
```

Run `pnpm install` to update the lockfile and patch TypeScript, then `pnpm check`.
The overlay promotes eight official Effect diagnostics to errors that fail
`tsc`; it requires the compiler patch. Base, service, and app-vite do not activate
those diagnostics. Configure editor support separately with
`pnpm --filter @monorepo/tool-tsconfig exec effect-tsgo setup`.

Install the Effect runtime in the application packages that use it, and
`@effect/vitest` only for Effect-aware tests. Neither is a peer dependency of the
Nopeus plugin. See the [Nopeus compiler setup](https://github.com/adamaho/nopeus/blob/dev/tools/tsconfig/README.md)
for diagnostic details.
