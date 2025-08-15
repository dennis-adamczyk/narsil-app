<?php

namespace Database\Factories;

#region USE

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;
use Narsil\Models\Entities\Entity;

#endregion

final class EntityFactory extends Factory
{
    #region PROPERTIES

    /**
     * {@inheritDoc}
     */
    protected $model = Entity::class;

    #endregion

    #region PUBLIC METHODS

    /**
     * {@inheritDoc}
     */
    public function definition(): array
    {
        return [
            Entity::UUID => Str::uuid()->toString(),
            Entity::CREATED_AT => now(),
            Entity::UPDATED_AT => now(),
            Entity::DELETED_AT => null,
        ];
    }

    #endregion
}
