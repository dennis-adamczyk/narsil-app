<?php

#region USE

use App\Providers\AppServiceProvider;
use Narsil\Providers\ComponentServiceProvider;
use Narsil\Providers\FieldServiceProvider;
use Narsil\Providers\FormRequestServiceProvider;
use Narsil\Providers\FormServiceProvider;
use Narsil\Providers\FortifyServiceProvider;

#endregion

return [
    AppServiceProvider::class,
    ComponentServiceProvider::class,
    FieldServiceProvider::class,
    FormServiceProvider::class,
    FormRequestServiceProvider::class,
    FortifyServiceProvider::class,
];
