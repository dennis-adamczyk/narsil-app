import { Button } from "@/blocks";
import {
  DropdownMenuContent,
  DropdownMenuRoot,
  DropdownMenuTrigger,
} from "@/components/dropdown-menu";
import { IconName } from "@/components/icon";
import { GlobalProps } from "@/types";
import { DropdownMenuItem } from "@narsil-cms/components/dropdown-menu";

type LayoutProps = {
  children: React.ReactNode & {
    props: GlobalProps;
  };
};

function Layout({ children }: LayoutProps) {
  const { footer, locales } = children.props;

  return (
    <div className="flex min-h-svh flex-col">
      <header className="bg-gray-50 text-gray-950">
        <div className="container mx-auto flex items-center justify-between p-4">
          <a className="text-xl font-bold" href="/">
            NARSIL
          </a>
          <nav className="flex gap-8 font-bold">
            <a className="text-gray-800 hover:text-gray-950" href="/narsil/dashboard">
              admin
            </a>
          </nav>
        </div>
      </header>
      <main className="grow bg-gray-950 text-gray-50">{children}</main>
      <footer className="bg-light mx-auto flex w-full flex-col gap-6 p-4 text-slate-900 md:gap-8 md:px-4 md:pt-6 lg:gap-10 lg:px-14 lg:pt-6 xl:px-20 xl:pt-8">
        <div className="flex flex-col justify-between gap-6 sm:flex-row">
          <div className="flex flex-col gap-6 md:gap-8 lg:gap-10">
            <div className="flex flex-wrap justify-between gap-6 md:items-center md:gap-8 lg:gap-12"></div>
            <div className="flex flex-row gap-10 text-base">
              <div className="flex flex-col gap-0.5 lg:gap-2">
                <p className="font-bold">{footer.company}</p>
                <p className="flex flex-col gap-0.5">
                  <span>{footer?.address_line_1}</span>
                  <span>{footer?.address_line_2}</span>
                </p>
              </div>
              <div className="flex flex-col justify-end">
                <Button
                  className="w-fit leading-6 text-slate-900 transition-colors duration-150 hover:text-pink-600 md:leading-normal"
                  asChild={true}
                  size="link"
                  variant="link"
                >
                  <a href={`mailto:${footer.email}`}>{footer.email}</a>
                </Button>
                <Button
                  className="w-fit leading-6 text-slate-900 transition-colors duration-150 hover:text-pink-600 md:leading-normal"
                  asChild={true}
                  size="link"
                  variant="link"
                >
                  <a href={`tel:${footer.phone?.replace(/\s+/g, "")}`}>{footer.phone}</a>
                </Button>
              </div>
            </div>
          </div>
          <div className="flex flex-row justify-between gap-6 sm:flex-col-reverse md:gap-8 lg:gap-10">
            <div className="flex gap-6">
              {footer.social_links?.map((socialLink, index) => {
                return (
                  <Button
                    asChild={true}
                    icon={socialLink.icon as IconName}
                    variant="ghost"
                    key={index}
                  >
                    <a href={socialLink.url} />
                  </Button>
                );
              })}
            </div>
            <DropdownMenuRoot>
              <DropdownMenuTrigger asChild={true}>
                <Button variant="ghost">Language</Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent>
                {locales[0]?.languages?.map((language, index) => {
                  return <DropdownMenuItem key={index}>{language.label}</DropdownMenuItem>;
                })}
              </DropdownMenuContent>
            </DropdownMenuRoot>
          </div>
        </div>
        <div className="flex flex-col flex-wrap content-center gap-2 border-t border-slate-200 pt-4 md:flex-row md:justify-between lg:gap-x-8">
          <div className="text-sm text-slate-700">{`©${new Date().getFullYear()} ${footer.company}. All rights reserved.`}</div>
        </div>
      </footer>
    </div>
  );
}

export default Layout;
