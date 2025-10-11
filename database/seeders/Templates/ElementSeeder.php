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
            Field::HANDLE => 'checkbox',
            Field::TYPE => CheckboxField::class,
        ], [
            Field::NAME => 'Checkbox',
            Field::SETTINGS => app(CheckboxField::class),
        ]);
    }

    /**
     * @return Block
     */
    protected function getRichTextBlock(): Block
    {
        $richTextField = $this->getRichTextField();

        $block = Block::firstOrCreate([
            Block::HANDLE => 'text',
        ], [
            Block::NAME => 'Text',
        ]);

        $block->fields()->sync([
            $richTextField->{Field::ID} => [
                BlockElement::HANDLE => $richTextField->{Field::HANDLE},
                BlockElement::NAME => json_encode(['en' => $richTextField->{Field::NAME}]),
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
            Field::HANDLE => 'rich_text',
            Field::TRANSLATABLE => true,
            Field::TYPE => RichTextField::class,
        ], [
            Field::NAME => 'Rich text',
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
            Field::HANDLE => 'string',
            Field::TRANSLATABLE => true,
            Field::TYPE => TextField::class,
        ], [
            Field::NAME => 'String',
            Field::SETTINGS => app(TextField::class),
        ]);
    }

    #endregion
}
