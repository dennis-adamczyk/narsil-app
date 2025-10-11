<?php

namespace Database\Seeders\Templates\Blocks;

#region USE

use Database\Seeders\Templates\ElementSeeder;
use Narsil\Models\Elements\Block;
use Narsil\Models\Elements\BlockElement;
use Narsil\Models\Elements\Field;

#endregion

final class OpenGraphSeeder extends ElementSeeder
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
        $stringField = $this->getStringField();

        $block = Block::firstOrCreate([
            Block::HANDLE => 'open_graph',
        ], [
            Block::NAME => 'Open Graph',
        ]);

        $block->fields()->attach($stringField->{Field::ID}, [
            BlockElement::HANDLE => 'open_graph_type',
            BlockElement::NAME => json_encode(['en' => 'Open Graph Type']),
            BlockElement::POSITION => 0,
        ]);

        $block->fields()->attach($stringField->{Field::ID}, [
            BlockElement::HANDLE => 'open_graph_title',
            BlockElement::NAME => json_encode(['en' => 'Open Graph Title']),
            BlockElement::POSITION => 1,
        ]);

        $block->fields()->attach($stringField->{Field::ID}, [
            BlockElement::HANDLE => 'open_graph_description',
            BlockElement::NAME => json_encode(['en' => 'Open Graph Description']),
            BlockElement::POSITION => 2,
        ]);

        $block->fields()->attach($stringField->{Field::ID}, [
            BlockElement::HANDLE => 'open_graph_image',
            BlockElement::NAME => json_encode(['en' => 'Open Graph Image']),
            BlockElement::POSITION => 3,
        ]);

        return $block;
    }

    #endregion
}
