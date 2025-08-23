<?php

namespace Database\Seeders\Templates\Fields;

#region USE

use Database\Seeders\Templates\Blocks\AccordionSeeder;
use Database\Seeders\Templates\ElementSeeder;
use Narsil\Contracts\Fields\BuilderElement;
use Narsil\Models\Elements\Block;
use Narsil\Models\Elements\Field;
use Narsil\Models\Elements\FieldBlock;

#endregion

final class BuilderSeeder extends ElementSeeder
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
        $accordionBlock = new AccordionSeeder()->run();
        $richTextBlock = $this->getRichTextBlock();

        $field = Field::firstOrCreate([
            Field::NAME => 'Builder',
            Field::HANDLE => 'builder',
            Field::TYPE => BuilderElement::class,
        ], [
            Field::SETTINGS => app(BuilderElement::class),
        ]);

        FieldBlock::firstOrCreate([
            FieldBlock::BLOCK_ID => $accordionBlock->{Block::ID},
            FieldBlock::FIELD_ID => $field->{Field::ID},
        ]);

        FieldBlock::firstOrCreate([
            FieldBlock::BLOCK_ID => $richTextBlock->{Block::ID},
            FieldBlock::FIELD_ID => $field->{Field::ID},
        ]);

        return $field;
    }

    #endregion
}
