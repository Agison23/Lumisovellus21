
export type RouteDefinition = {
  name: string;
  path: string;
  i18nNamespace: string; // namespace to pass to useTranslations(..)
  i18nKey: string; // key inside that namespace
};

export const routeDefinitions: RouteDefinition[] = [
  {
    name: 'Map',
    path: '/',
    i18nNamespace: 'AppLayout',
    i18nKey: 'map',
  },
  {
    name: 'Definitions',
    path: '/definitions',
    i18nNamespace: 'AppLayout',
    i18nKey: 'definitions',
  },
  {
    name: 'Weather',
    path: '/weather',
    i18nNamespace: 'AppLayout',
    i18nKey: 'weather',
  }
]

export type RouteKey = keyof typeof routeDefinitions;

/**
 * Build a path optionally prefixed with a locale (for route prefixing style `/fi/...`).
 * If you don't use locale prefixes in URLs, pass `locale` as `undefined` and you'll get the raw path.
 */
