import { type GlobalProps } from "@narsil-cms/hooks/use-props";

type LayoutProps = {
  children: React.ReactNode & {
    props: GlobalProps;
  };
};

function Layout({ children }: LayoutProps) {
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
      <footer className="bg-gray-50 text-gray-950">
        <div className="container mx-auto p-4 text-center">
          <span className="text-sm">&copy; 2026 Narsil. All rights reserved.</span>
        </div>
      </footer>
    </div>
  );
}

export default Layout;
