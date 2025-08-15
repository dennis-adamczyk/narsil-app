<?php

namespace Database\Seeders\Templates\Pages;

#region USE

use Illuminate\Database\Seeder;
use Narsil\Contracts\Fields\CheckboxInput;
use Narsil\Models\Elements\Block;
use Narsil\Models\Elements\BlockElement;
use Narsil\Models\Elements\Field;

#endregion

final class RobotsSeeder extends Seeder
{
    #region PUBLIC METHODS

    /**
     * @return Block
     */
    public function run(): Block
    {
        return $this->createRobotsBlock();
    }

    #endregion

    #region PRIVATE METHODS

    /**
     * @return Field
     */
    private function createNoFollowField(): Field
    {
        return Field::create([
            Field::NAME => 'No Follow',
            Field::HANDLE => 'nofollow',
            Field::TYPE => CheckboxInput::class,
            Field::SETTINGS => app(CheckboxInput::class),
        ]);
    }

    /**
     * @return Field
     */
    private function createNoIndexField(): Field
    {
        return Field::create([
            Field::NAME => 'No Index',
            Field::HANDLE => 'noindex',
            Field::TYPE => CheckboxInput::class,
            Field::SETTINGS => app(CheckboxInput::class),
        ]);
    }

    /**
     * @return Block
     */
    private function createRobotsBlock(): Block
    {
        $fields = [
            $this->createNoFollowField(),
            $this->createNoIndexField(),
        ];

        $block = Block::create([
            Block::NAME => 'Robots',
            Block::HANDLE => 'robots',
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

    #endregion
}
