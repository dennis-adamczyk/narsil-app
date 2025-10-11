<?php

namespace Database\Seeders\Templates\Blocks;

#region USE

use Database\Seeders\Templates\ElementSeeder;
use Narsil\Models\Elements\Block;
use Narsil\Models\Elements\BlockElement;
use Narsil\Models\Elements\Field;

#endregion

final class MetaSeeder extends ElementSeeder
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
        $stringField = $this->getStringField();

        $block = Block::firstOrCreate([
            Block::NAME => 'Meta',
            Block::HANDLE => 'meta',
        ]);

        $block->fields()->attach($stringField->{Field::ID}, [
            BlockElement::HANDLE => 'meta_title',
            BlockElement::NAME => json_encode(['en' => 'Meta Title']),
            BlockElement::POSITION => 0,
        ]);

        $block->fields()->attach($stringField->{Field::ID}, [
            BlockElement::HANDLE => 'meta_description',
            BlockElement::NAME => json_encode(['en' => 'Meta Description']),
            BlockElement::POSITION => 1,
        ]);

        return $block;
    }

    #endregion
}
