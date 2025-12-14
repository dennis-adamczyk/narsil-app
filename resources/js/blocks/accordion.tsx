import { Heading, Icon } from "@/blocks";
import {
  AccordionContent,
  AccordionHeader,
  AccordionItem,
  AccordionRoot,
  AccordionTrigger,
} from "@/components/accordion";
import { EntityBlock } from "@narsil-cms/types";

type AccordionProps = EntityBlock & {};

function Accordion({ children }: AccordionProps) {
  return (
    <AccordionRoot className="min-w-96" collapsible={true} type="single">
      {children.map((child) => {
        return (
          <AccordionItem value={child.uuid} key={child.uuid}>
            <AccordionHeader asChild>
              <Heading level="h2">
                <AccordionTrigger>
                  {child.fields[0].value}
                  <Icon
                    className={
                      "transition-transform duration-300 will-change-transform group-data-[state=open]:rotate-180"
                    }
                    name="chevron-down"
                  />
                </AccordionTrigger>
              </Heading>
            </AccordionHeader>
            <AccordionContent>
              <div
                className="prose pb-4"
                dangerouslySetInnerHTML={{ __html: child.fields[1].value }}
              />
            </AccordionContent>
          </AccordionItem>
        );
      })}
    </AccordionRoot>
  );
}

export default Accordion;
