"use client";

import { Check, ChevronsUpDown } from "lucide-react";
import * as React from "react";

import { Button } from "@/components/ui/button";
import {
	Command,
	CommandEmpty,
	CommandGroup,
	CommandInput,
	CommandItem,
	CommandList,
} from "@/components/ui/command";
import {
	Popover,
	PopoverContent,
	PopoverTrigger,
} from "@/components/ui/popover";
import { cn } from "@/lib/utils";

interface SnowTypeComboboxProps {
	value: string | null;
	onChange: (value: string | null) => void;
	options: { value: string; label: string }[];
	placeholder?: string;
	searchPlaceholder?: string;
	emptyText?: string;
}

export function SnowTypeCombobox({
	value,
	onChange,
	options,
	placeholder = "Select snow type...",
	searchPlaceholder = "Search snow type...",
	emptyText = "No snow type found.",
}: SnowTypeComboboxProps) {
	const [open, setOpen] = React.useState(false);

	return (
		<Popover open={open} onOpenChange={setOpen}>
			<PopoverTrigger asChild>
				<Button
					variant="outline"
					role="combobox"
					aria-expanded={open}
					className="w-full justify-between"
				>
					{value
						? options.find((option) => option.value === value)?.label
						: placeholder}
					<ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
				</Button>
			</PopoverTrigger>
			<PopoverContent className="w-[200px] p-0">
				<Command>
					<CommandInput placeholder={searchPlaceholder} className="h-9" />
					<CommandList>
						<CommandEmpty>{emptyText}</CommandEmpty>
						<CommandGroup>
							{options.map((option) => (
								<CommandItem
									key={option.value}
									value={option.label}
									onSelect={() => {
										onChange(option.value === value ? null : option.value);
										setOpen(false);
									}}
								>
									{option.label}
									<Check
										className={cn(
											"ml-auto h-4 w-4",
											value === option.value ? "opacity-100" : "opacity-0",
										)}
									/>
								</CommandItem>
							))}
						</CommandGroup>
					</CommandList>
				</Command>
			</PopoverContent>
		</Popover>
	);
}
