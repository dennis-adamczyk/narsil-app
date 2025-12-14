<?php

namespace App\Http\Middlewares;

#region USE

use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;
use Inertia\Middleware;

#endregions

/**
 * @version 1.0.0
 * @author Jonathan Rigaux
 */
class InertiaMiddleware extends Middleware
{
    #region PROPERTIES

    /**
     * The root template that's loaded on the first page visit.
     *
     * @see https://inertiajs.com/server-side-setup#root-template
     *
     * @var string
     */
    protected $rootView = 'frontend';

    #endreion

    #region PUBLIC METHODS

    /**
     * Determine the current asset version.
     *
     * @see https://inertiajs.com/asset-versioning
     */
    public function version(Request $request): ?string
    {
        return parent::version($request);
    }

    /**
     * Define the props that are shared by default.
     *
     * @see https://inertiajs.com/shared-data
     *
     * @return array<string, mixed>
     */
    public function share(Request $request): array
    {
        $session = $this->getSession($request);

        return [
            ...parent::share($request),
            'session' => $session,
        ];
    }

    #endregion

    #region PRIVATE METHODS

    /**
     * @param Request $request
     *
     * @return array
     */
    protected function getSession(Request $request): array
    {
        return [
            'locale' => App::getLocale(),
        ];
    }

    #endregion
}
