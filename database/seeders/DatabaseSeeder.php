<?php

namespace Database\Seeders;

#region USE

use Database\Seeders\TemplateSeeder;
use Database\Seeders\UserSeeder;
use Illuminate\Database\Seeder;

#endregion

final class DatabaseSeeder extends Seeder
{
    #region PUBLIC METHODS

    /**
     * @return void
     */
    public function run(): void
    {
        $this->call([
            TemplateSeeder::class,
            UserSeeder::class,
        ]);
    }

    #endregion
}
