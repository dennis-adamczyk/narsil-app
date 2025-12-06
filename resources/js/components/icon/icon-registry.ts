import dynamic from "@narsil-cms/lib/dynamic";
import { ChevronDownIcon, RabbitIcon } from "lucide-react";

export const icons = {
  ["default"]: RabbitIcon,
  ["chevron-down"]: ChevronDownIcon,
  ["instagram"]: dynamic(() => import("./icon-instagram")),
  ["linkedin"]: dynamic(() => import("./icon-linkedin")),
} as const;

export type IconName = keyof typeof icons;
