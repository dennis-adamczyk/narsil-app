<?php

namespace Database\Seeders\Templates;

#region USE

use Database\Seeders\Templates\Pages\BuilderSeeder;
use Database\Seeders\Templates\Pages\MetaSeeder;
use Database\Seeders\Templates\Pages\OpenGraphSeeder;
use Database\Seeders\Templates\Pages\RobotsSeeder;
use Illuminate\Database\Seeder;
use Narsil\Contracts\Fields\TextInput;
use Narsil\Models\Elements\Block;
use Narsil\Models\Elements\Field;
use Narsil\Models\Elements\Template;
use Narsil\Models\Elements\TemplateSection;
use Narsil\Models\Elements\TemplateSectionElement;

#endregion

final class PageSeeder extends Seeder
{
    #region PUBLIC METHODS

    /**
     * @return Template
     */
    public function run(): Template
    {
        $template = Template::create([
            Template::HANDLE => 'page',
            Template::NAME => 'Page',
        ]);

        $this->createMainSection($template);
        $this->createContentSection($template);
        $this->createSEOSection($template);

        return $template;
    }

    #endregion

    #region PRIVATE METHODS

    /**
     * @param Template $template
     *
     * @return TemplateSection
     */
    private function createMainSection(Template $template): TemplateSection
    {
        $elements = [
            $this->createTitleField(),
        ];

        $section = TemplateSection::create([
            TemplateSection::HANDLE => 'main',
            TemplateSection::NAME => 'Main',
            TemplateSection::TEMPLATE_ID => $template->{Template::ID},
        ]);

        foreach ($elements as $position => $element)
        {
            TemplateSectionElement::create([
                TemplateSectionElement::ELEMENT_ID => $element->{TemplateSectionElement::ID},
                TemplateSectionElement::ELEMENT_TYPE => $element::class,
                TemplateSectionElement::HANDLE => $element->{TemplateSectionElement::HANDLE},
                TemplateSectionElement::NAME => $element->{TemplateSectionElement::NAME},
                TemplateSectionElement::POSITION => $position,
                TemplateSectionElement::TEMPLATE_SECTION_ID => $section->{TemplateSection::ID},
            ]);
        }

        return $section;
    }

    /**
     * @param Template $template
     *
     * @return TemplateSection
     */
    private function createContentSection(Template $template): TemplateSection
    {
        $builderField = new BuilderSeeder()->run();

        $elements = [
            $builderField
        ];

        $section = TemplateSection::create([
            TemplateSection::HANDLE => 'content',
            TemplateSection::NAME => 'Content',
            TemplateSection::TEMPLATE_ID => $template->{Template::ID},
        ]);

        foreach ($elements as $position => $element)
        {
            TemplateSectionElement::create([
                TemplateSectionElement::ELEMENT_ID => $element->{TemplateSectionElement::ID},
                TemplateSectionElement::ELEMENT_TYPE => $element::class,
                TemplateSectionElement::HANDLE => $element->{TemplateSectionElement::HANDLE},
                TemplateSectionElement::NAME => $element->{TemplateSectionElement::NAME},
                TemplateSectionElement::POSITION => $position,
                TemplateSectionElement::TEMPLATE_SECTION_ID => $section->{TemplateSection::ID},
            ]);
        }

        return $section;
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

        $elements = [
            $metaBlock,
            $openGraphBlock,
            $robotsBlock
        ];

        $section = TemplateSection::create([
            TemplateSection::HANDLE => 'seo',
            TemplateSection::NAME => 'SEO',
            TemplateSection::TEMPLATE_ID => $template->{Template::ID},
        ]);

        foreach ($elements as $position => $element)
        {
            TemplateSectionElement::create([
                TemplateSectionElement::ELEMENT_ID => $element->{Block::ID},
                TemplateSectionElement::ELEMENT_TYPE => $element::class,
                TemplateSectionElement::HANDLE => $element->{Field::HANDLE},
                TemplateSectionElement::NAME => $element->{Field::NAME},
                TemplateSectionElement::POSITION => $position,
                TemplateSectionElement::TEMPLATE_SECTION_ID => $section->{TemplateSection::ID},
            ]);
        }

        return $section;
    }

    /**
     * @return Field
     */
    private function createTitleField(): Field
    {
        return Field::firstOrCreate([
            Field::NAME => 'Title',
            Field::HANDLE => 'title',
            Field::TYPE => TextInput::class,
        ], [
            Field::SETTINGS => app(TextInput::class),
        ]);
    }

    #endregion
}
