<?php

namespace App\Livewire;

#region USE

use Illuminate\View\View;
use Livewire\Component;

#endregion

final class Page extends Component
{
    #region PUBLIC METHODS

    /**
     * {@inheritDoc}
     */
    public function render(): View
    {
        return view('livewire.page');
    }

    #endregion
}
