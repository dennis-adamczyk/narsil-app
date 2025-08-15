<?php

namespace Database\Seeders\Templates\Pages;

#region USE

use Illuminate\Database\Seeder;
use Narsil\Contracts\Fields\TextInput;
use Narsil\Models\Elements\Block;
use Narsil\Models\Elements\BlockElement;
use Narsil\Models\Elements\Field;

#endregion

final class OpenGraphSeeder extends Seeder
{
    #region PUBLIC METHODS

    /**
     * @return Block
     */
    public function run(): Block
    {
        return $this->createOpenGraphBlock();
    }

    #endregion

    #region PRIVATE METHODS

    /**
     * @return Block
     */
    private function createOpenGraphBlock(): Block
    {
        $fields = [
            $this->createOpenGraphTypeField(),
            $this->createOpenGraphTitleField(),
            $this->createOpenGraphDescriptionField(),
            $this->createOpenGraphImageField(),
        ];

        $block = Block::create([
            Block::NAME => 'Open Graph',
            Block::HANDLE => 'open_graph',
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
    private function createOpenGraphDescriptionField(): Field
    {
        return Field::create([
            Field::NAME => 'Open Graph Description',
            Field::HANDLE => 'open_graph_description',
            Field::TYPE => TextInput::class,
            Field::SETTINGS => app(TextInput::class),
        ]);
    }

    /**
     * @return Field
     */
    private function createOpenGraphImageField(): Field
    {
        return Field::create([
            Field::NAME => 'Open Graph Image',
            Field::HANDLE => 'open_graph_image',
            Field::TYPE => TextInput::class,
            Field::SETTINGS => app(TextInput::class),
        ]);
    }

    /**
     * @return Field
     */
    private function createOpenGraphTitleField(): Field
    {
        return Field::create([
            Field::NAME => 'Open Graph Title',
            Field::HANDLE => 'open_graph_title',
            Field::TYPE => TextInput::class,
            Field::SETTINGS => app(TextInput::class),
        ]);
    }

    /**
     * @return Field
     */
    private function createOpenGraphTypeField(): Field
    {
        return Field::create([
            Field::NAME => 'Open Graph Type',
            Field::HANDLE => 'open_graph_type',
            Field::TYPE => TextInput::class,
            Field::SETTINGS => app(TextInput::class),
        ]);
    }

    #endregion
}
