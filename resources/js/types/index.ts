import { HostLocale } from "@narsil-cms/types";
import { Footer } from "./models";

export * from "./models";

export type GlobalProps = {
  locales: HostLocale[];
  footer: Footer;
};
