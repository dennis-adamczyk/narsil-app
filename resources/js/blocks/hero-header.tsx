import type { EntityBlock } from "@narsil-cms/types";
import Button from "./button";
import Container from "./container";
import Heading from "./heading";

type HeroHeaderProps = EntityBlock & {
  excerpt: string;
  headline: string;
  hero_header_buttons: EntityBlock[];
};

function HeroHeader({ excerpt, headline, ...props }: HeroHeaderProps) {
  return (
    <Container>
      <Heading level="h1" variant="h1">
        {headline}
      </Heading>
      <div dangerouslySetInnerHTML={{ __html: excerpt }} />
      <Button
        className="transition-transform duration-200 will-change-transform hover:scale-105"
        asChild={true}
        size="lg"
      >
        {/* <a href={props.fields[2].value} target="_blank">
          Create now
        </a> */}
      </Button>
    </Container>
  );
}

export default HeroHeader;
