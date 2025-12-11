import { HostLocale, SiteUrl } from "@narsil-cms/types";
import { Footer } from "./models";

export * from "./models";

export type GlobalProps = {
  locales: HostLocale[];
  page: Record<string, unknown> & { urls: SiteUrl[] };
  footer: Footer;
};
