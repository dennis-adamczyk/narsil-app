<?php

namespace Database\Seeders\Templates\Blocks;

#region USE

use Database\Seeders\Templates\ElementSeeder;
use Narsil\Contracts\Fields\BuilderField;
use Narsil\Models\Elements\Block;
use Narsil\Models\Elements\BlockElement;
use Narsil\Models\Elements\Field;
use Narsil\Models\Elements\FieldBlock;

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
        $accordionItemContentField = $this->createAccordionContentField();

        $block = Block::firstOrCreate([

            Block::HANDLE => 'accordion',
        ], [
            Block::NAME => 'Accordion',
        ]);

        $block->fields()->sync([
            $accordionItemContentField->{Field::ID} => [
                BlockElement::HANDLE => $accordionItemContentField->{Field::HANDLE},
                BlockElement::NAME => json_encode(['en' => $accordionItemContentField->{Field::NAME}]),
                BlockElement::POSITION => 0,
            ],
        ]);

        return $block;
    }

    /**
     * @return Field
     */
    private function createAccordionContentField(): Field
    {
        $accordionItemBlock = $this->createAccordionItemBlock();

        $field = Field::firstOrCreate([
            Field::HANDLE => 'accordion_builder',
            Field::TYPE => BuilderField::class,
        ], [
            Field::NAME => 'Items',
        ]);

        FieldBlock::firstOrCreate([
            FieldBlock::BLOCK_ID => $accordionItemBlock->{Block::ID},
            FieldBlock::FIELD_ID => $field->{Block::ID},
        ]);

        return $field;
    }

    /**
     * @return Block
     */
    private function createAccordionItemBlock(): Block
    {
        $stringField = $this->getStringField();
        $accordionItemContentField = $this->createAccordionItemContentField();

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
            $accordionItemContentField->{Field::ID} => [
                BlockElement::HANDLE => $accordionItemContentField->{Field::HANDLE},
                BlockElement::NAME => json_encode(['en' => $accordionItemContentField->{Field::NAME}]),
                BlockElement::POSITION => 0,
            ],
        ]);

        return $block;
    }

    /**
     * @return Field
     */
    private function createAccordionItemContentField(): Field
    {
        $richTextBlock = $this->getRichTextBlock();

        $field = Field::firstOrCreate([
            Field::HANDLE => 'accordion_item_builder',
            Field::TYPE => BuilderField::class,
        ], [
            Field::NAME => 'Content',
        ]);

        FieldBlock::firstOrCreate([
            FieldBlock::BLOCK_ID => $richTextBlock->{Block::ID},
            FieldBlock::FIELD_ID => $field->{Block::ID},
        ]);

        return $field;
    }

    #endregion
}
