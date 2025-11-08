<?php

#region USE

use App\Http\Controllers\SeederController;
use App\Livewire\Page;
use Illuminate\Support\Facades\Route;

#endregion

Route::domain('{subdomain}')
    ->get('/{path?}', Page::class)
    ->where('path', '.*');

Route::get('/{path?}', Page::class)
    ->where('path', '.*');

Route::post('/narsil/seed', SeederController::class)
    ->name('narsil.seed');
