import { Container } from "@/blocks";
import BlockRenderer from "@/blocks/block-renderer";
import { GlobalProps } from "@/types";
import { Head } from "@inertiajs/react";

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
          page.content.blocks.map((block, index) => {
            return <BlockRenderer block={block} key={index} />;
          })}
      </Container>
    </>
  );
}

export default Page;
