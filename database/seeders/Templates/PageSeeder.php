<?php

namespace Database\Seeders\Templates;

#region USE

use Database\Seeders\Templates\Blocks\AccordionSeeder;
use Database\Seeders\Templates\Blocks\MetaSeeder;
use Database\Seeders\Templates\Blocks\OpenGraphSeeder;
use Database\Seeders\Templates\Blocks\RobotsSeeder;
use Narsil\Models\Elements\Block;
use Narsil\Models\Elements\Field;
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

            $this->attachSets($template);
            $this->createMainSection($template);
            $this->createSEOSection($template);

            MigrationService::syncTable($template);
        }

        return $template;
    }

    #endregion

    #region PRIVATE METHODS

    /**
     * @param Template $template
     *
     * @return void
     */
    private function attachSets(Template $template): void
    {
        $accordionBlock = new AccordionSeeder()->run();
        $richTextBlock = $this->getRichTextBlock();

        $template->sets()->sync([
            $accordionBlock->{Block::ID},
            $richTextBlock->{Block::ID},
        ]);
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

    /**
     * @param Template $template
     *
     * @return TemplateSection
     */
    private function createSEOSection(Template $template): TemplateSection
    {
        $metaBlock = new MetaSeeder()->run();
        $openGraphBlock = new OpenGraphSeeder()->run();
        $robotsBlock = new RobotsSeeder()->run();

        $templateSection = TemplateSection::firstOrCreate([
            TemplateSection::HANDLE => 'seo',
            TemplateSection::TEMPLATE_ID => $template->{Template::ID},
        ], [
            TemplateSection::NAME => 'SEO',
        ]);

        $templateSection->blocks()->sync([
            $metaBlock->{Field::ID} => [
                TemplateSection::HANDLE => $metaBlock->{Block::HANDLE},
                TemplateSection::NAME => json_encode(['en' => $metaBlock->{Block::NAME}]),
                TemplateSection::POSITION => 0,
            ],
            $openGraphBlock->{Field::ID} => [
                TemplateSection::HANDLE => $openGraphBlock->{Block::HANDLE},
                TemplateSection::NAME => json_encode(['en' => $openGraphBlock->{Block::NAME}]),
                TemplateSection::POSITION => 1,
            ],
            $robotsBlock->{Field::ID} => [
                TemplateSection::HANDLE => $robotsBlock->{Block::HANDLE},
                TemplateSection::NAME => json_encode(['en' => $robotsBlock->{Block::NAME}]),
                TemplateSection::POSITION => 2,
            ],
        ]);

        return $templateSection;
    }

    #endregion
}
