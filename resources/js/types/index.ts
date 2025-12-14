import { HostLocale, SiteUrl } from "@narsil-cms/types";
import { Footer } from "./models";

export * from "./models";

export type GlobalProps = {
  footer: Footer;
  locales: HostLocale[];
  page: Record<string, unknown> & { urls: SiteUrl[] };
  session: {
    locale: string;
  };
};
