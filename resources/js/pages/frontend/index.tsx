import { Button, Container, Heading } from "@/blocks";
import { GlobalProps } from "@/types";

function Page({page}: GlobalProps) {
  return page ?(
    <Container>
    </Container>
  ) : (
    <Container>
      <Heading level="h1" variant="h1">
        Welcome to <span className="text-primary">Narsil CMS</span>
      </Heading>
      <p>Visit the admin panel to create your own content.</p>
      <Button
        className="transition-transform duration-200 will-change-transform hover:scale-105"
        asChild={true}
        size="lg"
      >
        <a href="/narsil/dashboard">Create now</a>
      </Button>
    </Container>
  );
}

export default Page;
