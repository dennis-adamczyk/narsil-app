import { createInertiaApp } from "@inertiajs/react";
import { createRoot } from "react-dom/client";

import Layout from "@narsil-cms/layouts/layout";

createInertiaApp({
  resolve: (name) => {
    const [vendorPath, componentPath] = name.includes("::")
      ? name.split("::")
      : [null, name];

    const appPages = import.meta.glob("@/pages/**/*.tsx", {
      eager: true,
    });
    const vendorPages = import.meta.glob("@narsil-cms/pages/**/*.tsx", {
      eager: true,
    });

    const appKey = `/resources/js/pages/${componentPath}.tsx`;
    const vendorKey = `/vendor/${vendorPath}/resources/js/pages/${componentPath}.tsx`;

    const page: any = appPages[appKey] ?? vendorPages[vendorKey];

    if (!page) {
      throw new Error(`Page not found: ${name}`);
    }

    page.default.layout =
      page.default?.layout ||
      ((page: React.ReactNode) => <Layout children={page} />);

    return page;
  },
  setup({ el, App, props }) {
    createRoot(el).render(<App {...props} />);
  },
});
