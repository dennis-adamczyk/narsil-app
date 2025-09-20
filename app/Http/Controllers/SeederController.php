<?php

namespace App\Http\Controllers;

#region USE

use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Artisan;

#endregion

class SeederController extends Controller
{
    #region PUBLIC METHODS

    /**
     * @return Request $request
     */
    public function __invoke(Request $request): RedirectResponse
    {
        Artisan::call('migrate --seed');

        return back()->with('success', trans('toasts.success.seed'));
    }

    #endregion
}
