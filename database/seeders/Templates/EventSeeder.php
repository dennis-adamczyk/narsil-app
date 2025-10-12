<?php

namespace Database\Seeders\Templates;

#region USE

use Narsil\Models\Elements\Field;
use Narsil\Models\Elements\Template;
use Narsil\Models\Elements\TemplateSection;
use Narsil\Models\Elements\TemplateSectionElement;
use Narsil\Services\MigrationService;

#endregion

final class EventSeeder extends ElementSeeder
{
    #region PUBLIC METHODS

    /**
     * @return Template
     */
    public function run(): Template
    {
        $template = Template::query()
            ->where(Template::HANDLE, 'events')
            ->first();

        if (!$template)
        {
            $template = Template::firstOrCreate([
                Template::HANDLE => 'events',
            ], [
                Template::NAME => 'Events',
            ]);

            $this->createMainSection($template);

            MigrationService::syncTable($template);
        }

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
            TemplateSection::TEMPLATE_ID => $template->{Template::ID},
        ], [
            TemplateSection::NAME => 'Main',
        ]);

        $templateSection->fields()->attach($stringField->{Field::ID}, [
            TemplateSectionElement::HANDLE => 'title',
            TemplateSectionElement::NAME => json_encode(['en' => 'Title']),
            TemplateSectionElement::POSITION => 0,
        ]);

        return $templateSection;
    }

    #endregion
}
