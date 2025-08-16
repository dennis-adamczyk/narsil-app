<?php

namespace Database\Seeders;

#region USE

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
        $entity = new Entity([
            Entity::ID => 1,
        ]);

        $entity->setTable($template->{Template::HANDLE});

        $entity->save();

        return $entity;
    }

    /**
     * @param Template $template
     *
     * @return array<Entity>
     */
    private function createProducts(Template $template): array
    {
        $products = [];

        foreach (range(1, 10) as $index)
        {
            $product = new Entity([
                Entity::ID => $index,
                'title' => fake()->slug(),
            ]);

            $product->setTable($template->{Template::HANDLE});

            $product->save();
        }

        return $products;
    }

    #endregion
}
