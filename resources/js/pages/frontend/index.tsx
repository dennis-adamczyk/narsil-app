import { Button, Container, Heading } from "@/blocks";
import BlockRenderer from "@/blocks/block-renderer";
import { GlobalProps } from "@/types";
import { Fragment } from "react/jsx-runtime";

function Page({ page }: GlobalProps) {
  return page.content ? (
    <Container>
      {page.content.map((identifier, index) => {
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
  ) : (
    <Container>
      <Heading level="h1" variant="h1">
        Welcome to <span className="text-primary">Narsil CMS</span>
      </Heading>
      <p>Visit the admin panel to create your own content.</p>
      <Button
        className="transition-transform duration-200 will-change-transform hover:scale-105"
        asChild={true}
        size="lg"
      >
        <a href="/narsil/dashboard" target="_blank">
          Create now
        </a>
      </Button>
    </Container>
  );
}

export default Page;
