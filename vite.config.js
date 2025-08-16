import { defineConfig, loadEnv } from "vite";
import path, { dirname } from "node:path";
import { fileURLToPath } from "node:url";
import laravel from "laravel-vite-plugin";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), "");

  const __dirname = dirname(fileURLToPath(import.meta.url));

  return {
    optimizeDeps: {
      exclude: ["@narsil-cms"],
    },
    plugins: [
      laravel({
        input: ["resources/css/app.css", "resources/js/app.tsx"],
        refresh: true,
      }),
      react(),
      tailwindcss(),
    ],
    resolve: {
      alias: {
        "@": path.join(__dirname, "/resources/js"),
        "@narsil-cms": path.join(__dirname, "/vendor/narsil/cms/resources/js"),
      },
      dedupe: ["react", "react-dom"],
    },
    server: {
      allowedHosts: true,
      cors: {
        origin:
          /https?:\/\/([A-Za-z0-9\-\.]+)?(localhost|\.local|\.test|\.site)(?::\d+)?$/,
      },
      fs: {
        strict: false,
      },
      headers: {
        "Access-Control-Allow-Private-Network": "true",
      },
      host: "0.0.0.0",
      origin: env.APP_URL + ":5173",
      port: 5173,
      strictPort: true,
    },
  };
});
