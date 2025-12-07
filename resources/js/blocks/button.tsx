import { Icon } from "@/blocks";
import { ButtonRoot } from "@/components/button";
import { type IconName } from "@/components/icon";
import { Link } from "@inertiajs/react";
import { Slot } from "radix-ui";
import { type ComponentProps } from "react";

type ButtonProps = ComponentProps<typeof ButtonRoot> & {
  icon?: IconName;
  iconProps?: ComponentProps<typeof Icon>;
  linkProps?: ComponentProps<typeof Link>;
};

function Button({ asChild = false, children, icon, iconProps, linkProps, ...props }: ButtonProps) {
  const iconName = icon || iconProps?.name;

  return linkProps ? (
    <ButtonRoot asChild={linkProps ? true : asChild} {...props}>
      <Link {...linkProps}>
        {iconName ? <Icon name={iconName} {...iconProps} /> : null}
        <Slot.Slottable>{children}</Slot.Slottable>
      </Link>
    </ButtonRoot>
  ) : (
    <ButtonRoot asChild={linkProps ? true : asChild} {...props}>
      {iconName ? <Icon name={iconName} {...iconProps} /> : null}
      <Slot.Slottable>{children}</Slot.Slottable>
    </ButtonRoot>
  );
}

export default Button;
