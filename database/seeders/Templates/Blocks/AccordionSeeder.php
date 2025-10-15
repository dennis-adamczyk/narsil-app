<?php

namespace Database\Seeders\Templates\Blocks;

#region USE

use Database\Seeders\Templates\ElementSeeder;
use Narsil\Models\Elements\Block;
use Narsil\Models\Elements\BlockElement;
use Narsil\Models\Elements\BlockSet;
use Narsil\Models\Elements\Field;

#endregion

final class AccordionSeeder extends ElementSeeder
{
    #region PUBLIC METHODS

    /**
     * @return Block
     */
    public function run(): Block
    {
        return $this->createAccordionBlock();
    }

    #endregion

    #region PRIVATE METHODS

    /**
     * @return Block
     */
    private function createAccordionBlock(): Block
    {
        $accordionItemSet = $this->createAccordionItemBlock();

        $block = Block::firstOrCreate([

            Block::HANDLE => 'accordion',
        ], [
            Block::NAME => 'Accordion',
        ]);

        BlockSet::firstOrCreate([
            BlockSet::BLOCK_ID => $block->{Block::ID},
            BlockSet::SET_ID => $accordionItemSet->{Block::ID},
        ]);

        return $block;
    }

    /**
     * @return Block
     */
    private function createAccordionItemBlock(): Block
    {
        $stringField = $this->getStringField();

        $block = Block::firstOrCreate([
            Block::HANDLE => 'accordion_item',
        ], [
            Block::NAME => 'Accordion Item',
        ]);

        $block->fields()->sync([
            $stringField->{Field::ID} => [
                BlockElement::HANDLE => 'title',
                BlockElement::NAME => json_encode(['en' => 'Title']),
                BlockElement::POSITION => 0,
            ],
        ]);

        $richTextBlock = $this->getRichTextBlock();

        BlockSet::firstOrCreate([
            BlockSet::BLOCK_ID => $block->{Block::ID},
            BlockSet::SET_ID => $richTextBlock->{Block::ID},
        ]);

        return $block;
    }

    #endregion
}
