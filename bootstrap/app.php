<?php

#region USE

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Narsil\Http\Middleware\Inertia\HandleInertiaRequests;
use Narsil\Http\Middleware\LocaleMiddleware;
use Symfony\Component\HttpFoundation\Response;

#endregion

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__ . '/../routes/web.php',
        commands: __DIR__ . '/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void
    {
        $middleware->web(append: [
            LocaleMiddleware::class,
            HandleInertiaRequests::class,
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions): void
    {
        $exceptions->respond(function (Response $response, Throwable $exception, Request $request)
        {
            $code = $response->getStatusCode();

            $isError = in_array($code, [
                403,
                404,
                500,
                503,
            ]);

            if (!app()->environment(['local']) && $isError)
            {
                return Inertia::render('narsil/cms::error', [
                    'code' => $code,
                    'description' => trans(`narsil-cms::errors.descriptions.$code`),
                    'title' => trans(`narsil-cms::errors.titles.$code`),
                ])
                    ->toResponse($request)
                    ->setStatusCode($response->getStatusCode());
            }

            return $response;
        });
    })->create();
