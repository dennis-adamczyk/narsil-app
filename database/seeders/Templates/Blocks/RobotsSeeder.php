<?php

namespace Database\Seeders\Templates\Blocks;

#region USE

use Database\Seeders\Templates\ElementSeeder;
use Narsil\Models\Elements\Block;
use Narsil\Models\Elements\BlockElement;
use Narsil\Models\Elements\Field;

#endregion

final class RobotsSeeder extends ElementSeeder
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
     * @return Block
     */
    private function createRobotsBlock(): Block
    {
        $checkboxField = $this->getCheckboxField();

        $block = Block::firstOrCreate([
            Block::HANDLE => 'robots',
        ], [
            Block::NAME => 'Robots',
        ]);

        $block->fields()->attach($checkboxField->{Field::ID}, [
            BlockElement::HANDLE => 'nofollow',
            BlockElement::NAME => json_encode(['en' => 'No Follow']),
            BlockElement::POSITION => 0,
        ]);

        $block->fields()->attach($checkboxField->{Field::ID}, [
            BlockElement::HANDLE => 'noindex',
            BlockElement::NAME => json_encode(['en' => 'No Index']),
            BlockElement::POSITION => 1,
        ]);

        return $block;
    }

    #endregion
}
