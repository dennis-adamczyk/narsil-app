import { Entity, HostLocale, SiteUrl } from "@narsil-cms/types";
import { Footer } from "./models";

export * from "./models";

export type GlobalProps = {
  footer: Footer;
  locales: HostLocale[];
  page: { content: string[]; entities: Record<string, Entity>; urls: SiteUrl[] };
  session: {
    locale: string;
  };
};
