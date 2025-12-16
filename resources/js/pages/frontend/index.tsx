import { Container } from "@/blocks";
import BlockRenderer from "@/blocks/block-renderer";
import { GlobalProps } from "@/types";
import { Head } from "@inertiajs/react";
import { Fragment } from "react/jsx-runtime";

function Page({ page }: GlobalProps) {
  return (
    <>
      <Head>
        <title>{page.title}</title>
        <meta name="description" content={page.meta_description} />
        <meta property="og:title" content={page.open_graph_title || page.title} />
        <meta
          property="og:description"
          content={page.open_graph_description || page.meta_description}
        />
        <meta property="og:image" content={page.open_graph_image} />
        <meta property="og:type" content={page.open_graph_type || "website"} />
      </Head>
      <Container>
        {page.content &&
          page.content.map((identifier, index) => {
            const entity = page.entities[identifier];

            return (
              <Fragment key={index}>
                {entity.blocks.map((entityBlock, index) => (
                  <BlockRenderer {...entityBlock} key={index} />
                ))}
              </Fragment>
            );
          })}
      </Container>
    </>
  );
}

export default Page;
