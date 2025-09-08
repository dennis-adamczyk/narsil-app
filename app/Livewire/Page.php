<?php

namespace App\Livewire;

#region USE

use Livewire\Component;

#endregion

final class Page extends Component
{
    #region PUBLIC METHODS

    /**
     * {@inheritDoc}
     */
    public function render()
    {
        return view('livewire.page');
    }

    #endregion
}
