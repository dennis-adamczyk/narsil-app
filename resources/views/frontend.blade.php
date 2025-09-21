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
		<title>{{ $title ?? 'Page Title' }}</title>
		@vite('resources/css/frontend.css')
	</head>
	<header class="bg-gray-800 p-4 text-white">
		<div class="container mx-auto flex items-center justify-between">
			<h1 class="text-xl font-bold">My Website</h1>
			<nav class="space-x-4">
				<a
					class="hover:underline"
					href="/"
				>Home</a>
				<a
					class="hover:underline"
					href="/about"
				>About</a>
				<a
					class="hover:underline"
					href="/contact"
				>Contact</a>
			</nav>
		</div>
	</header>

	<body>
		{{ $slot }}
	</body>
	<footer class="mt-auto bg-gray-800 p-4 text-white">
		<div class="container mx-auto text-center">
			&copy; {{ date('Y') }} My Website. All rights reserved.
		</div>
	</footer>

</html>
