<!DOCTYPE html>

<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

	<head>
		<meta charset="utf-8" />
		<meta
			content="width=device-width, initial-scale=1.0, maximum-scale=5.0"
			name="viewport"
		/>
		<link
			href="/favicon.svg"
			rel="icon"
		/>

		@inertiaHead
		@routes
		@viteReactRefresh
		@vite(['resources/css/app.css', 'resources/js/app.tsx'])

	</head>

	<body>
		@inertia
	</body>

</html>
