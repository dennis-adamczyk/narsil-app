import type { Footer, SitePage } from "./models";

export * from "./models";

export type GlobalProps = {
  footer: Footer;
  page: SitePage;
  session: {
    locale: string;
  };
};
