import type { SitePageBlock } from "@/types";
import Accordion from "./accordion";
import Button from "./button";
import HeroHeader from "./hero-header";

type BlockRendererProps = {
  block: SitePageBlock;
  [key: string]: unknown;
};

const blocks = {
  ["accordion"]: Accordion,
  ["button"]: Button,
  ["hero_header"]: HeroHeader,
};

type BlockName = keyof typeof blocks;

function BlockRenderer({ block, ...props }: BlockRendererProps) {
  const BlockComponent = blocks[block.handle as BlockName];

  return BlockComponent ? <BlockComponent {...block} {...props} /> : null;
}

export default BlockRenderer;
