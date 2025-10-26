<?php

namespace Database\Seeders\Templates;

#region USE

use Database\Seeders\Templates\Blocks\AccordionSeeder;
use Narsil\Contracts\Fields\BuilderField;
use Narsil\Models\Elements\Block;
use Narsil\Models\Elements\Field;
use Narsil\Models\Elements\FieldBlock;
use Narsil\Models\Elements\Template;
use Narsil\Models\Elements\TemplateSection;
use Narsil\Services\MigrationService;

#endregion

final class PageSeeder extends ElementSeeder
{
    #region PUBLIC METHODS

    /**
     * @return Template
     */
    public function run(): Template
    {
        $template = Template::query()
            ->where(Template::HANDLE, 'pages')
            ->first();

        if (!$template)
        {
            $template = Template::firstOrCreate([
                Template::HANDLE => 'pages',
            ], [
                Template::NAME => 'Pages',
            ]);

            $this->createMainSection($template);
            $this->createContentSection($template);

            MigrationService::syncTable($template);
        }

        return $template;
    }

    #endregion

    #region PRIVATE METHODS

    /**
     * @return Field
     */
    private function createContentField(): Field
    {
        $accordionBlock = new AccordionSeeder()->run();

        $field = Field::firstOrCreate([
            Field::HANDLE => 'content',
            Field::TYPE => BuilderField::class,
        ], [
            Field::NAME => 'Content',
        ]);

        FieldBlock::firstOrCreate([
            FieldBlock::BLOCK_ID => $accordionBlock->{Block::ID},
            FieldBlock::FIELD_ID => $field->{Block::ID},
        ]);

        return $field;
    }

    /**
     * @param Template $template
     *
     * @return TemplateSection
     */
    private function createContentSection(Template $template): TemplateSection
    {
        $contentField = $this->createContentField();

        $templateSection = TemplateSection::firstOrCreate([
            TemplateSection::HANDLE => 'content',
            TemplateSection::TEMPLATE_ID => $template->{Template::ID},
        ], [
            TemplateSection::NAME => 'Content',
        ]);

        $templateSection->fields()->attach($contentField->{Block::ID}, [
            TemplateSection::HANDLE => $contentField->{Block::HANDLE},
            TemplateSection::NAME => json_encode(['en' => $contentField->{Block::NAME}]),
            TemplateSection::POSITION => 0,
        ]);

        return $templateSection;
    }

    /**
     * @param Template $template
     *
     * @return TemplateSection
     */
    private function createMainSection(Template $template): TemplateSection
    {
        $stringField = $this->getStringField();

        $templateSection = TemplateSection::firstOrCreate([
            TemplateSection::HANDLE => 'main',
            TemplateSection::TEMPLATE_ID => $template->{Template::ID},
        ], [
            TemplateSection::NAME => 'Main',
        ]);

        $templateSection->fields()->attach($stringField->{Field::ID}, [
            TemplateSection::HANDLE => 'title',
            TemplateSection::NAME => json_encode(['en' => 'Title']),
            TemplateSection::POSITION => 0,
        ]);

        return $templateSection;
    }
}
