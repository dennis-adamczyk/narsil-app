<?php

#region USE

use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

#endregion

Route::get('/', function ()
{
    return Inertia::render('index');
});
