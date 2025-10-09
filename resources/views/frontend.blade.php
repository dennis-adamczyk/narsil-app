<!DOCTYPE html>

<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

	<head>
		<meta charset="utf-8">
		<meta
			content="width=device-width, initial-scale=1.0, maximum-scale=5.0"
			name="viewport"
		>
		<link
			href="/favicon.svg"
			rel="icon"
		/>
		<title>{{ $title ?? 'Page title' }}</title>
		<meta
			content="{{ $description ?? 'Page description' }}"
			name="description"
		>
		@vite('resources/css/frontend.css')
	</head>

	<body class="antialiased">
		<x-header />
		<main class="container mx-auto flex items-center justify-between p-4">
			{{ $slot }}
		</main>
		<x-footer />
	</body>

	</main>

</html>
