import { createInertiaApp } from "@inertiajs/react";
import { createRoot } from "react-dom/client";
import BackendLayout from "@narsil-cms/layouts/layout";
import FrontendLayout from "./layouts/layout";
import React from "react";

createInertiaApp({
  resolve: (name) => {
    const [vendorPath, componentPath] = name.includes("::")
      ? name.split("::")
      : [null, name];

    const pages = (() => {
      switch (vendorPath) {
        case "narsil/cms":
          return import.meta.glob("@narsil-cms/pages/**/*.tsx", {
            eager: true,
          });
        default:
          return import.meta.glob("@/pages/**/*.tsx", { eager: true });
      }
    })();

    const page: any =
      pages[
        vendorPath
          ? `/vendor/${vendorPath}/resources/js/pages/${componentPath}.tsx`
          : `/resources/js/pages/${componentPath}.tsx`
      ];

    page.default.layout =
      page.default?.layout ||
      ((page: React.ReactNode) =>
        vendorPath ? (
          <BackendLayout children={page} />
        ) : (
          <FrontendLayout children={page} />
        ));

    return page;
  },
  setup({ el, App, props }) {
    createRoot(el).render(<App {...props} />);
  },
});
