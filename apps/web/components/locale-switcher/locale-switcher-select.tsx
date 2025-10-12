"use client"
import { Locale } from "@/i18n/config";
import { setUserLocale } from "@/i18n/locale";
import { useTransition } from "react";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "../ui/select";
import { Language } from "iconoir-react";

type Props = {
  defaultValue: string;
  items: Array<{value: string; label: string}>;
  label: string;
}

export function LocaleSwitcherSelect({defaultValue, items, label}: Props) {
  const [isPending, startTransition] = useTransition();

  function onChange(value: string) {
    const locale = value as Locale;
    startTransition(() => {
      setUserLocale(locale);
    })
  }
  return (
    <div className="relative">
      <Select defaultValue={defaultValue} onValueChange={onChange} disabled={isPending}>
        <SelectTrigger>
          <Language />
          <SelectValue placeholder={label} />
        </SelectTrigger>
        <SelectContent>
          {items.map((item) => (
            <SelectItem
              key={item.value}
              value={item.value}
              onSelect={() => onChange(item.value)}
              className="cursor-pointer"
            >
              {item.label}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
    </div>
  )
}
