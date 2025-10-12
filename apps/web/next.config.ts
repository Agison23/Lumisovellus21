
// eslint-disable-next-line @typescript-eslint/no-unused-vars, unused-imports/no-unused-imports
import type { NextConfig } from "next";
import createNextIntlPlugin from "next-intl/plugin";

const nextConfig: NextConfig = {
  /* config options here */
};

const withNextIntl = createNextIntlPlugin();

export default withNextIntl(nextConfig);
