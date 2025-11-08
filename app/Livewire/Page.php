<?php

namespace App\Livewire;

#region USE

use Illuminate\View\View;
use Livewire\Component;
use Narsil\Services\PageService;

#endregion

final class Page extends Component
{
    #region PUBLIC METHODS

    /**
     * {@inheritDoc}
     */
    public function render(): View
    {
        // dd(PageService::resolveURL(request()));

        return view('livewire.page');
    }

    #endregion
}
