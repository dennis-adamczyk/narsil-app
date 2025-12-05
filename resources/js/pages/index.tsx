function Page() {
  return (
    <section className="col-span-12 justify-self-center py-16">
      <div className="flex min-w-0 flex-col items-center justify-center gap-8 rounded-lg border-dashed border-gray-300 p-6 text-center text-balance md:p-12">
        <h1 className="text-4xl font-medium tracking-tight">
          Welcome to <span className="text-pink-600">Narsil CMS</span>
        </h1>
        <p>Visit the admin panel to create your own content.</p>
        <a
          className="inline-flex items-center justify-center rounded bg-pink-600/90 px-4 py-2 text-lg font-medium text-white shadow-md transition-transform duration-200 will-change-transform hover:scale-105 hover:bg-pink-600"
          href="/narsil/dashboard"
        >
          Website erstellen
        </a>
      </div>
    </section>
  );
}

export default Page;
