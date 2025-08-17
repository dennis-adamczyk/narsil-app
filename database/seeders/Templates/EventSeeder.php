<?php

namespace Database\Seeders\Templates;

#region USE

use Illuminate\Database\Seeder;
use Narsil\Contracts\Fields\TextInput;
use Narsil\Models\Elements\Field;
use Narsil\Models\Elements\Template;
use Narsil\Models\Elements\TemplateSection;
use Narsil\Models\Elements\TemplateSectionElement;

#endregion

final class EventSeeder extends Seeder
{
    #region PUBLIC METHODS

    /**
     * @return Template
     */
    public function run(): Template
    {
        $template = Template::create([
            Template::HANDLE => 'events',
            Template::NAME => 'Events',
        ]);

        $this->createMainSection($template);

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
