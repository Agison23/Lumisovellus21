/**
 * Generate an identifier from a snow type name.
 * Converts the name to lowercase and replaces spaces with underscores.
 * 
 * @param name - The snow type name
 * @returns The generated identifier
 */
export function generateSnowTypeIdentifier(name: string): string {
  return name.toLowerCase().replace(/\s+/g, '_');
}

