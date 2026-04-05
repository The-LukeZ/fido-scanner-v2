// @ts-check
import { defineConfig } from "astro/config";

import svelte from "@astrojs/svelte";
import { paraglideVitePlugin } from "@inlang/paraglide-js";

// https://astro.build/config
export default defineConfig({
  integrations: [svelte()],

  site: "https://fidoscan.thelukez.com/",
  prefetch: true,
  trailingSlash: "ignore",

  vite: {
    plugins: [
      paraglideVitePlugin({
        project: "./project.inlang",
        outdir: "./src/paraglide",
        strategy: ["url", "baseLocale"],
        disableAsyncLocalStorage: true,
        cleanOutdir: true,
      }),
    ],
  },

  output: "static",

  i18n: {
    defaultLocale: "en",
    locales: ["en", "de"],
  },
});
