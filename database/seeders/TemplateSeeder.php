<?php

namespace Database\Seeders;

#region USE

use Database\Factories\EntityFactory;
use Database\Seeders\Templates\PageSeeder;
use Database\Seeders\Templates\ProductSeeder;
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
        $pageTemplate = new PageSeeder()->run();
        $productTemplate = new ProductSeeder()->run();

        $this->createPage($pageTemplate);
        $this->createProducts($productTemplate);
    }

    #endregion

    #region PRIVATE METHODS

    /**
     * @param Template $template
     *
     * @return Entity
     */
    private function createPage(Template $template): Entity
    {
        $template = new ProductSeeder()->run();

        return EntityFactory::new()
            ->create([
                Entity::TEMPLATE_ID => $template->{Template::ID},
            ]);
    }

    /**
     * @param Template $template
     *
     * @return array<Entity>
     */
    private function createProducts(Template $template): array
    {
        $template = new ProductSeeder()->run();

        return EntityFactory::new()
            ->count(10)
            ->create([
                Entity::TEMPLATE_ID => $template->{Template::ID},
            ])
            ->toArray();
    }

    #endregion
}
