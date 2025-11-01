<?php

namespace App\Providers;

#region USE

use Illuminate\Support\ServiceProvider;

#endregion

final class AppServiceProvider extends ServiceProvider
{
    #region PUBLIC METHODS

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot(): void
    {
        //
    }

    /**
     * {@inheritDoc}
     */
    public function register(): void
    {
        //
    }

    #endregion
}
