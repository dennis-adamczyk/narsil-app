<?php

namespace Database\Seeders\Templates;

#region USE

use Narsil\Models\Elements\Field;
use Narsil\Models\Elements\Template;
use Narsil\Models\Elements\TemplateSection;
use Narsil\Models\Elements\TemplateSectionElement;
use Narsil\Services\MigrationService;
use Narsil\Services\TemplateService;

#endregion

final class EventSeeder extends ElementSeeder
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

        MigrationService::syncTable($template);

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
        $stringField = $this->getStringField();

        $templateSection = TemplateSection::firstOrCreate([
            TemplateSection::HANDLE => 'main',
            TemplateSection::NAME => 'Main',
            TemplateSection::TEMPLATE_ID => $template->{Template::ID},
        ]);

        $templateSection->fields()->attach($stringField->{Field::ID}, [
            TemplateSectionElement::HANDLE => 'title',
            TemplateSectionElement::NAME => 'Title',
            TemplateSectionElement::POSITION => 0,
        ]);

        return $templateSection;
    }

    #endregion
}
