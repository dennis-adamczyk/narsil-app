import { Button, Container, Heading } from "@/blocks";

function Page() {
  return (
    <Container>
      <Heading level="h1" variant="h1">
        Welcome to <span className="text-primary">Narsil CMS</span>
      </Heading>
      <p>Visit the admin panel to create your own content.</p>
      <Button
        className="transition-transform duration-200 will-change-transform hover:scale-105"
        linkProps={{
          href: "/narsil/dashboard",
        }}
        size="lg"
      >
        Website erstellen
      </Button>
    </Container>
  );
}

export default Page;
