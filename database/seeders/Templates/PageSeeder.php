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

#endregion

final class PageSeeder extends ElementSeeder
{
    #region PUBLIC METHODS

    /**
     * @return Template
     */
    public function run(): Template
    {
        $template = Template::create([
            Template::HANDLE => 'pages',
            Template::NAME => 'Pages',
        ]);

        $this->attachSets($template);
        $this->createMainSection($template);
        $this->createSEOSection($template);

        $template->refresh()->load([
            Template::RELATION_SECTIONS . '.' . TemplateSection::RELATION_ELEMENTS,
        ]);

        $template->touch();

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
            TemplateSection::NAME => 'Main',
            TemplateSection::TEMPLATE_ID => $template->{Template::ID},
        ]);

        $templateSection->fields()->attach($stringField->{Field::ID}, [
            TemplateSection::HANDLE => 'title',
            TemplateSection::NAME => 'Title',
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

        $templateSection = TemplateSection::create([
            TemplateSection::HANDLE => 'seo',
            TemplateSection::NAME => 'SEO',
            TemplateSection::TEMPLATE_ID => $template->{Template::ID},
        ]);

        $templateSection->blocks()->sync([
            $metaBlock->{Field::ID} => [
                TemplateSection::HANDLE => $metaBlock->{Block::HANDLE},
                TemplateSection::NAME => $metaBlock->{Block::NAME},
                TemplateSection::POSITION => 0,
            ],
            $openGraphBlock->{Field::ID} => [
                TemplateSection::HANDLE => $openGraphBlock->{Block::HANDLE},
                TemplateSection::NAME => $openGraphBlock->{Block::NAME},
                TemplateSection::POSITION => 1,
            ],
            $robotsBlock->{Field::ID} => [
                TemplateSection::HANDLE => $robotsBlock->{Block::HANDLE},
                TemplateSection::NAME => $robotsBlock->{Block::NAME},
                TemplateSection::POSITION => 2,
            ],
        ]);

        return $templateSection;
    }

    #endregion
}
