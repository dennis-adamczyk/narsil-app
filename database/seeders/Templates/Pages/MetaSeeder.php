<?php

namespace Database\Seeders\Templates\Pages;

#region USE

use Illuminate\Database\Seeder;
use Narsil\Contracts\Fields\TextInput;
use Narsil\Models\Elements\Block;
use Narsil\Models\Elements\BlockElement;
use Narsil\Models\Elements\Field;

#endregion

final class MetaSeeder extends Seeder
{
    #region PUBLIC METHODS

    /**
     * @return Block
     */
    public function run(): Block
    {
        return $this->createMetaBlock();
    }

    #endregion

    #region PRIVATE METHODS

    /**
     * @return Block
     */
    private function createMetaBlock(): Block
    {
        $fields = [
            $this->createMetaTitleField(),
            $this->createMetaDescriptionField(),
        ];

        $block = Block::create([
            Block::NAME => 'Meta',
            Block::HANDLE => 'meta',
        ]);

        foreach ($fields as $position => $field)
        {
            $block->fields()->attach($field->{Field::ID}, [
                BlockElement::HANDLE => $field->{Field::HANDLE},
                BlockElement::NAME => $field->{Field::NAME},
                BlockElement::POSITION => $position,
            ]);
        }

        return $block;
    }

    /**
     * @return Field
     */
    private function createMetaDescriptionField(): Field
    {
        return Field::create([
            Field::NAME => 'Meta Description',
            Field::HANDLE => 'meta_description',
            Field::TYPE => TextInput::class,
            Field::SETTINGS => app(TextInput::class),
        ]);
    }

    /**
     * @return Field
     */
    private function createMetaTitleField(): Field
    {
        return Field::create([
            Field::NAME => 'Meta Title',
            Field::HANDLE => 'meta_title',
            Field::TYPE => TextInput::class,
            Field::SETTINGS => app(TextInput::class),
        ]);
    }

    #endregion
}
