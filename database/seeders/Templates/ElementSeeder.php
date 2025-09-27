<?php

namespace Database\Seeders\Templates;

#region USE

use Illuminate\Database\Seeder;
use Narsil\Contracts\Fields\CheckboxField;
use Narsil\Contracts\Fields\RichTextField;
use Narsil\Contracts\Fields\TextField;
use Narsil\Enums\Forms\RichTextEditorEnum;
use Narsil\Models\Elements\Block;
use Narsil\Models\Elements\BlockElement;
use Narsil\Models\Elements\Field;

#endregion

abstract class ElementSeeder extends Seeder
{
    #region PROTECTED METHODS

    /**
     * @return Field
     */
    protected function getCheckboxField(): Field
    {
        return Field::firstOrCreate([
            Field::NAME => 'Checkbox',
            Field::HANDLE => 'checkbox',
            Field::TYPE => CheckboxField::class,
        ], [
            Field::SETTINGS => app(CheckboxField::class),
        ]);
    }

    /**
     * @return Block
     */
    protected function getRichTextBlock(): Block
    {
        $field = $this->getRichTextField();

        $block = Block::firstOrCreate([
            Block::NAME => 'Text',
            Block::HANDLE => 'text',
        ]);

        $block->fields()->sync([
            $field->{Field::ID} => [
                BlockElement::HANDLE => $field->{Field::HANDLE},
                BlockElement::NAME => $field->{Field::NAME},
                BlockElement::POSITION => 0,
            ],
        ]);

        return $block;
    }

    /**
     * @return Field
     */
    protected function getRichTextField(): Field
    {
        return Field::firstOrCreate([
            Field::NAME => 'Rich text',
            Field::HANDLE => 'rich_text',
            Field::TYPE => RichTextField::class,
        ], [
            Field::SETTINGS => app(RichTextField::class)
                ->setModules(RichTextEditorEnum::values()),
        ]);
    }

    /**
     * @return Field
     */
    protected function getStringField(): Field
    {
        return Field::firstOrCreate([
            Field::NAME => 'string',
            Field::HANDLE => 'string',
            Field::TYPE => TextField::class,
        ], [
            Field::SETTINGS => app(TextField::class),
        ]);
    }

    #endregion
}
