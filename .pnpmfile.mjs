// Published Nopeus packages declare `engines.node: ^24.22.1`, which blocks
// installs on Node 26 under `engineStrict`. Widen only their range until Nopeus
// releases with Node 26 support, then delete this file.
const nopeusPackage = /^@adamaho\/nopeus-/;

/**
 * pnpm install hooks that widen Nopeus engine ranges for Node 26.
 *
 * @category pnpm
 * @since 0.0.0
 */
export const hooks = {
  readPackage(manifest) {
    if (nopeusPackage.test(manifest.name) && manifest.engines?.node === "^24.22.1") {
      manifest.engines = { ...manifest.engines, node: "^24.22.1 || ^26.12.1" };
    }

    return manifest;
  },
};
