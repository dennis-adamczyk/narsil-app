import { HostLocale, SitePage } from "@narsil-cms/types";
import { Footer } from "./models";

export * from "./models";

export type GlobalProps = {
  footer: Footer;
  locales: HostLocale[];
  page: SitePage;
  session: {
    locale: string;
  };
};
