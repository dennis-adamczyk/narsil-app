<?php

namespace Database\Seeders;

#region USE

use Database\Seeders\Templates\EventSeeder;
use Database\Seeders\Templates\PageSeeder;
use Illuminate\Database\Seeder;
use Narsil\Models\Elements\Template;
use Narsil\Models\Entities\Entity;

#endregion

final class TemplateSeeder extends Seeder
{
    #region PUBLIC METHODS

    /**
     * @return void
     */
    public function run(): void
    {
        $eventTemplate = new EventSeeder()
            ->run();
        $pageTemplate = new PageSeeder()
            ->run();

        $this->createEvents($eventTemplate);
        $this->createPage($pageTemplate);
    }

    #endregion

    #region PRIVATE METHODS

    /**
     * @param Template $template
     *
     * @return array<Entity>
     */
    private function createEvents(Template $template): array
    {
        $events = [];

        foreach (range(1, 10) as $index)
        {
            $event = new Entity([
                Entity::ID => $index,
                'title' => fake()->slug(),
            ]);

            $event->setTable($template->{Template::HANDLE});

            $event->save();

            $events[] = $event;
        }

        return $events;
    }

    /**
     * @param Template $template
     *
     * @return Entity
     */
    private function createPage(Template $template): Entity
    {
        $entity = new Entity([
            Entity::ID => 1,
        ]);

        $entity->setTable($template->{Template::HANDLE});

        $entity->save();

        return $entity;
    }

    #endregion
}
