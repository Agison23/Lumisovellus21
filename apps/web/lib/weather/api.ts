export function getBackendUrl() {
  return process.env.NEXT_PUBLIC_BACKEND_URL || "http://localhost:3001";
}

export function api(path: string) {
  return `${getBackendUrl()}${path}`;
}
