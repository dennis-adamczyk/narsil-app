<?php

#region USE

use App\Http\Controllers\SeederController;
use App\Http\Middlewares\InertiaMiddleware;
use Illuminate\Support\Facades\Route;
use Narsil\Http\Controllers\PageController;

#endregion

Route::middleware([
    InertiaMiddleware::class,
])->group(function ()
{
    Route::get('/{path?}', PageController::class)
        ->where('path', '.*');

    Route::domain('{subdomain}')
        ->get('/{path?}', PageController::class)
        ->where('path', '.*');
});

Route::post('/narsil/seed', SeederController::class)
    ->name('narsil.seed');
