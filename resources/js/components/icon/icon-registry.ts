import { ChevronDownIcon, RabbitIcon } from "lucide-react";

export const icons = {
  ["default"]: RabbitIcon,
  ["chevron-down"]: ChevronDownIcon,
} as const;

export type IconName = keyof typeof icons;
