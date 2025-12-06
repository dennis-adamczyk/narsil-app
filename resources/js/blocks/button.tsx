import { Icon } from "@/blocks";
import { ButtonRoot } from "@/components/button";
import { type IconName } from "@/components/icon";
import { Link } from "@inertiajs/react";
import { type ComponentProps } from "react";

type ButtonProps = ComponentProps<typeof ButtonRoot> & {
  icon?: IconName;
  iconProps?: ComponentProps<typeof Icon>;
  label?: string;
  linkProps?: ComponentProps<typeof Link>;
};

function Button({
  asChild = false,
  children,
  icon,
  iconProps,
  label,
  linkProps,
  ...props
}: ButtonProps) {
  const iconName = icon || iconProps?.name;

  const ButtonContent = (
    <>
      {iconName ? <Icon name={iconName} {...iconProps} /> : null}
      {children ?? label}
    </>
  );

  const ButtonElement = (
    <ButtonRoot asChild={linkProps ? true : asChild} {...props}>
      {linkProps ? <Link {...linkProps}>{ButtonContent}</Link> : ButtonContent}
    </ButtonRoot>
  );

  return ButtonElement;
}

export default Button;
