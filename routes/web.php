<?php

#region USE

use App\Livewire\Page;
use Illuminate\Support\Facades\Route;

#endregion

Route::get('/{slug?}', Page::class)
    ->where('slug', '.*');
