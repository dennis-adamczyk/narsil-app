import type { EntityBlock } from "@narsil-cms/types";
import Accordion from "./accordion";
import HeroHeader from "./hero-header";

type BlockRendererProps = EntityBlock & {};

const blocks = {
  ["accordion"]: Accordion,
  ["hero_header"]: HeroHeader,
};

type BlockName = keyof typeof blocks;

function BlockRenderer({ ...props }: BlockRendererProps) {
  const BlockComponent = blocks[props.block.handle as BlockName];

  return BlockComponent ? <BlockComponent {...props} /> : null;
}

export default BlockRenderer;
