<?php

#region USE

use App\Http\Controllers\SeederController;
use App\Livewire\Page;
use Illuminate\Support\Facades\Route;

#endregion

Route::get('/{slug?}', Page::class)
    ->where('slug', '.*');

Route::post('/narsil/seed', SeederController::class)
    ->name('narsil.seed');
