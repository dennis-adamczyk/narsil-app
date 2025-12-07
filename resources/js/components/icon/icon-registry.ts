import dynamic from "@narsil-cms/lib/dynamic";
import { CheckIcon, ChevronDownIcon, ChevronRightIcon, CircleIcon, RabbitIcon } from "lucide-react";

export const icons = {
  ["check"]: CheckIcon,
  ["chevron-down"]: ChevronDownIcon,
  ["chevron-right"]: ChevronRightIcon,
  ["circle"]: CircleIcon,
  ["default"]: RabbitIcon,
  ["instagram"]: dynamic(() => import("./icon-instagram")),
  ["linkedin"]: dynamic(() => import("./icon-linkedin")),
} as const;

export type IconName = keyof typeof icons;
