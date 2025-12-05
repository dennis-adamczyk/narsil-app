import { createInertiaApp } from "@inertiajs/react";
import { type ComponentProps } from "react";
import { createRoot } from "react-dom/client";
import Layout from "./layouts/layout";

createInertiaApp({
  resolve: (name) => {
    const appPages = import.meta.glob("@/pages/**/*.tsx", {
      eager: true,
    });

    const appKey = `/resources/js/pages/${name}.tsx`;

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const page: any = appPages[appKey];

    if (!page) {
      throw new Error(`Page not found: ${name}`);
    }

    page.default.layout =
      page.default?.layout ||
      ((page: ComponentProps<typeof Layout>["children"]) => <Layout children={page} />);

    return page;
  },
  setup({ el, App, props }) {
    createRoot(el).render(<App {...props} />);
  },
});
