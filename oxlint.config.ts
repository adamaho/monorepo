import base from "@adamaho/nopeus-oxlint-config";
import syntax from "@adamaho/nopeus-oxlint-plugin/base";
import { defineConfig } from "oxlint";

export default defineConfig({
  extends: [base, syntax],
});
