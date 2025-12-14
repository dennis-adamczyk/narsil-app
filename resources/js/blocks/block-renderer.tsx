import type { EntityBlock } from "@narsil-cms/types";
import Accordion from "./accordion";

type BlockRendererProps = EntityBlock & {};

const blocks = {
  accordion: Accordion,
};

type BlockName = keyof typeof blocks;

function BlockRenderer({ ...props }: BlockRendererProps) {
  const BlockComponent = blocks[props.block.handle as BlockName];

  return <BlockComponent {...props} />;
}

export default BlockRenderer;
