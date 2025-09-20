import { Link } from "@inertiajs/react";
import { route } from "ziggy-js";

import { Heading } from "@narsil-cms/blocks";
import {
  SectionContent,
  SectionHeader,
  SectionRoot,
} from "@narsil-cms/components/section";

function Dashboard() {
  return (
    <SectionRoot className="h-full p-8">
      <SectionHeader>
        <Heading level="h1" variant="h5">
          Welcome to Narsil CMS.
        </Heading>
      </SectionHeader>
      <SectionContent className="flex flex-col gap-4">
        <p>
          This page is an example of how you can override a default CMS view
          with your own implementation.
        </p>
        <p>
          Need sample data? You can{" "}
          <Link
            className="cursor-pointer font-bold text-primary hover:underline"
            href={route("narsil.seed")}
            method="post"
          >
            seed the database
          </Link>{" "}
          with one click.
        </p>
      </SectionContent>
    </SectionRoot>
  );
}

export default Dashboard;
