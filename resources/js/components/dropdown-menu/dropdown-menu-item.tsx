import { cn } from "@narsil-cms/lib/utils";
import { DropdownMenu } from "radix-ui";
import { type ComponentProps } from "react";

type DropdownMenuItemProps = ComponentProps<typeof DropdownMenu.Item> & {
  inset?: boolean;
  variant?: "default";
};

function DropdownMenuItem({
  className,
  inset,
  variant = "default",
  ...props
}: DropdownMenuItemProps) {
  return (
    <DropdownMenu.Item
      data-slot="dropdown-menu-item"
      data-inset={inset}
      data-variant={variant}
      className={cn(
        "relative flex w-full cursor-pointer items-center justify-start gap-2 rounded-md px-2 py-1.5 outline-hidden select-none",
        "focus:bg-accent focus:text-accent-foreground focus-visible:ring-0!",
        "data-disabled:pointer-events-none data-disabled:opacity-50",
        "data-inset:pl-8",
        "[&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4 [&_svg:not([class*='text-'])]:text-muted-foreground",
        className,
      )}
      {...props}
    />
  );
}

export default DropdownMenuItem;
