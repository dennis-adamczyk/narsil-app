<?php

namespace Database\Seeders\Templates\Blocks;

#region USE

use Database\Seeders\Templates\ElementSeeder;
use Narsil\Contracts\Fields\BuilderElement;
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
        $builderField = $this->createAccordionBuilderField();

        $block = Block::create([
            Block::NAME => 'Accordion',
            Block::HANDLE => 'accordion',
        ]);

        $block->fields()->sync([
            $builderField->{Field::ID} => [
                BlockElement::HANDLE => $builderField->{Field::HANDLE},
                BlockElement::NAME => $builderField->{Field::NAME},
                BlockElement::POSITION => 0,
            ],
        ]);

        return $block;
    }

    /**
     * @return Field
     */
    private function createAccordionBuilderField(): Field
    {
        $accordionItemBlock = $this->createAccordionItemBlock();

        $field = Field::firstOrCreate([
            Field::NAME => 'Accordion Builder',
            Field::HANDLE => 'accordion_builder',
            Field::TYPE => BuilderElement::class,
        ], [
            Field::SETTINGS => app(BuilderElement::class),
        ]);

        FieldBlock::firstOrCreate([
            FieldBlock::BLOCK_ID => $accordionItemBlock->{Block::ID},
            FieldBlock::FIELD_ID => $field->{Field::ID},
        ]);

        return $field;
    }

    /**
     * @return Block
     */
    private function createAccordionItemBlock(): Block
    {
        $builderField = $this->createAccordionItemBuilderField();
        $stringField = $this->getStringField();

        $block = Block::firstOrCreate([
            Block::NAME => 'Accordion Item',
            Block::HANDLE => 'accordion_item',
        ]);

        $block->fields()->sync([
            $stringField->{Field::ID} => [
                BlockElement::HANDLE => 'title',
                BlockElement::NAME => 'Title',
                BlockElement::POSITION => 0,
            ],
            $builderField->{Field::ID} => [
                BlockElement::HANDLE => $builderField->{Field::HANDLE},
                BlockElement::NAME => $builderField->{Field::NAME},
                BlockElement::POSITION => 0,
            ],
        ]);

        return $block;
    }

    /**
     * @return Field
     */
    private function createAccordionItemBuilderField(): Field
    {
        $richTextBlock = $this->getRichTextBlock();

        $field = Field::firstOrCreate([
            Field::NAME => 'Accordion Item Builder',
            Field::HANDLE => 'accordion_item_builder',
            Field::TYPE => BuilderElement::class,
        ], [
            Field::SETTINGS => app(BuilderElement::class),
        ]);

        FieldBlock::firstOrCreate([
            FieldBlock::BLOCK_ID => $richTextBlock->{Block::ID},
            FieldBlock::FIELD_ID => $field->{Field::ID},
        ]);

        return $field;
    }

    #endregion
}
