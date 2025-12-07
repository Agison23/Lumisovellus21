"use client"
import {Languages} from "lucide-react";
import {useTransition} from "react";
import {Select, SelectContent, SelectItem, SelectTrigger, SelectValue} from "../ui/select";
import {useAuth} from "@/hooks/use-auth";
import {Locale} from "@/i18n/config";
import {setUserLocale} from "@/i18n/locale";

type Props = {
  defaultValue: string;
  items: Array<{ value: string; label: string }>;
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

  const loggedIn = useAuth();

  return (
    <div className="relative">
      <Select defaultValue={defaultValue} onValueChange={onChange} disabled={isPending}>
        <SelectTrigger>
          <Languages size={14}/>
          <SelectValue className="text-xs" placeholder={label}/>
        </SelectTrigger>
        <SelectContent>
          {items.map((item) => (
            <SelectItem
              key={item.value}
              value={item.value}
              onSelect={() => onChange(item.value)}
              className="cursor-pointer text-xs"
            >
              {item.label}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
    </div>
  )
}
