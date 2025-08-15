<?php

namespace Database\Seeders\Templates\Pages;

#region USE

use Illuminate\Database\Seeder;
use Narsil\Contracts\Fields\BuilderElement;
use Narsil\Contracts\Fields\RichTextInput;
use Narsil\Models\Elements\Block;
use Narsil\Models\Elements\BlockElement;
use Narsil\Models\Elements\Field;
use Narsil\Models\Elements\FieldBlock;

#endregion

final class BuilderSeeder extends Seeder
{
    #region PUBLIC METHODS

    /**
     * @return Field
     */
    public function run(): Field
    {
        return $this->createBuilderField();
    }

    #endregion

    #region PRIVATE METHODS

    /**
     * @return Field
     */
    private function createBuilderField(): Field
    {
        $blocks = [
            $this->createRichTextBlock(),
        ];

        $field = Field::create([
            Field::NAME => 'Builder',
            Field::HANDLE => 'builder',
            Field::TYPE => BuilderElement::class,
            Field::SETTINGS => app(BuilderElement::class),
        ]);

        foreach ($blocks as $block)
        {
            FieldBlock::create([
                FieldBlock::BLOCK_ID => $block->{Block::ID},
                FieldBlock::FIELD_ID => $field->{Field::ID},
            ]);
        }

        return $field;
    }

    /**
     * @return Block
     */
    private function createRichTextBlock(): Block
    {
        $field = Field::create([
            Field::NAME => 'Rich text',
            Field::HANDLE => 'rich_text',
            Field::TYPE => RichTextInput::class,
            Field::SETTINGS => app(RichTextInput::class),
        ]);

        $block = Block::create([
            Block::NAME => 'Rich text',
            Block::HANDLE => 'rich_text',
        ]);

        $block->fields()->attach($field->{Field::ID}, [
            BlockElement::HANDLE => $field->{Field::HANDLE},
            BlockElement::NAME => $field->{Field::NAME},
            BlockElement::POSITION => 0,
        ]);

        return $block;
    }

    #endregion
}
