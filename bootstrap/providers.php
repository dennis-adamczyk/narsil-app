<?php

#region USE

use App\Providers\AppServiceProvider;
use Narsil\Providers\ComponentServiceProvider;
use Narsil\Providers\FieldSettingsServiceProvider;
use Narsil\Providers\FormRequestServiceProvider;
use Narsil\Providers\FormServiceProvider;
use Narsil\Providers\FortifyServiceProvider;

#endregion

return [
    AppServiceProvider::class,
    ComponentServiceProvider::class,
    FieldSettingsServiceProvider::class,
    FormServiceProvider::class,
    FormRequestServiceProvider::class,
    FortifyServiceProvider::class,
];
