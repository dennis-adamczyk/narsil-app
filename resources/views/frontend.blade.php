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

	<body class="flex min-h-screen flex-col">
		<x-header />
		<main class="flex-grow">
			{{ $slot }}
		</main>
		<x-footer />
	</body>

	</main>

</html>
