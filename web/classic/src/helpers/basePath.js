function normalizeBasePath(value) {
  if (!value || value === '/') {
    return '';
  }

  let normalized = value.trim();
  if (!normalized.startsWith('/')) {
    normalized = `/${normalized}`;
  }

  return normalized.replace(/\/+$/, '');
}

const viteBasePath =
  import.meta.env.BASE_URL && import.meta.env.BASE_URL !== '/'
    ? import.meta.env.BASE_URL
    : '';

export const ROUTER_BASENAME = normalizeBasePath(
  import.meta.env.VITE_ROUTER_BASENAME || viteBasePath,
);

export function withRouterBasename(path = '/') {
  if (!ROUTER_BASENAME) {
    return path || '/';
  }

  if (!path || path === '/') {
    return `${ROUTER_BASENAME}/`;
  }

  if (/^[a-z][a-z\d+\-.]*:/i.test(path) || path.startsWith('//')) {
    return path;
  }

  return `${ROUTER_BASENAME}${path.startsWith('/') ? '' : '/'}${path}`;
}

export function getApiBaseUrl() {
  return import.meta.env.VITE_REACT_APP_SERVER_URL || ROUTER_BASENAME || '';
}
