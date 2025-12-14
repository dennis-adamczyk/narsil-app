import type { EntityBlock } from "@narsil-cms/types";
import Button from "./button";
import Container from "./container";
import Heading from "./heading";

type HeroHeaderProps = EntityBlock & {};

function HeroHeader({ ...props }: HeroHeaderProps) {
  return (
    <Container>
      <Heading level="h1" variant="h1">
        {props.fields[0].value}
      </Heading>
      <div dangerouslySetInnerHTML={{ __html: props.fields[1].value }} />
      <Button
        className="transition-transform duration-200 will-change-transform hover:scale-105"
        asChild={true}
        size="lg"
      >
        <a href={props.fields[2].value} target="_blank">
          Create now
        </a>
      </Button>
    </Container>
  );
}

export default HeroHeader;
