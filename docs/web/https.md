# HTTPS Configuration

This document explains how HTTPS is wired for the production and beta environments on the lumisovellus.fi VM. It covers domains, Nginx, Docker, Certbot, and how the Next.js app talks to the backend without mixed content.

The following guide follows the docker compose deployment described in [Deployment Guide](deployment.md).

## High-level architecture

The VM runs Nginx as a reverse proxy and TLS terminator. All HTTPS traffic from the internet hits Nginx on port 443. Nginx decrypts TLS, then forwards plain HTTP to Docker containers running on the same VM.

For the beta environment, the flow is:

Browser → `https://beta.lumisovellus.fi` (443) → Nginx →

Next.js web container on `127.0.0.1:51001` (frontend)

and

Backend container on `127.0.0.1:51000` (API, behind /backend-api).

TLS is only handled by Nginx. Docker containers run HTTP only.

## Domains and DNS

The following hostnames are relevant:

`lumisovellus.fi` and `www.lumisovellus.fi` point to the VM and are served by the main Nginx “default” server. This is the production web app, proxied to a Node process on `localhost:3000`.

`pallas.lumisovellus.fi` also points to the same VM and is served by a separate server block in the same Nginx default file. It exposes backend endpoints under `/data/api/` and `/api/file/` via HTTP proxy to a local service.

`beta.lumisovellus.fi` is the beta/staging environment. It has an A record pointing to the same VM IP and is served by a separate Nginx site (`/etc/nginx/sites-available/dev.lumisovellus.fi`, despite the filename).

All these hostnames have Let’s Encrypt certificates managed by Certbot and stored under `/etc/letsencrypt/live/<hostname>/`.

## Docker services

### Backend

The important piece is the port mapping `51000:4004`. The backend listens on port 4004 inside the container; Docker publishes that on host port 51000. From the VM or Nginx, the backend base URL is `http://127.0.0.1:51000`.

API endpoints follow the pattern `http://127.0.0.1:51000/api/v1/....`

### Web

The app listens on 51001 inside the container and Docker publishes that on host port 51001. From Nginx, the frontend is `http://127.0.0.1:51001`.

The .env file used at build time and runtime is `../../apps/web/.env` from the project root.

## Nginx configuration

Nginx virtual host configs live under `/etc/nginx/sites-available` and are enabled via symlinks in `/etc/nginx/sites-enabled`.

You can see which sites are enabled with:

```bash
ls -l /etc/nginx/sites-enabled/
```

The relevant files are:

`/etc/nginx/sites-available/default`

Main production host and some API vhosts (including `pallas.lumisovellus.fi`).

`/etc/nginx/sites-available/dev.lumisovellus.fi`

Used for `beta.lumisovellus.fi` (the filename is historical and does not matter to Nginx).

The beta host is configured in /etc/nginx/sites-available/dev.lumisovellus.fi, symlinked into sites-enabled as dev.lumisovellus.fi.

The file contains two server blocks:

One HTTP server that just redirects to HTTPS:

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name beta.lumisovellus.fi;

    return 301 https://$host$request_uri;
}
```

One HTTPS server that terminates TLS and proxies to the beta containers:

```nginx
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name beta.lumisovellus.fi;

    ssl_certificate /etc/letsencrypt/live/beta.lumisovellus.fi/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/beta.lumisovellus.fi/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    # Backend: exposed under /backend-api/, proxied to Docker backend on 51000
    location /backend-api/ {
        proxy_pass http://127.0.0.1:51000/;
        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For
            $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Frontend: Next.js app on Docker web container at 51001
    location / {
        proxy_pass http://127.0.0.1:51001;
        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For
            $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Path handling for the backend is subtle but important:

Incoming request from the browser:

`https://beta.lumisovellus.fi/backend-api/api/v1/observations`

Nginx matches `location /backend-api/`. It strips the `/backend-api/` prefix and then appends the remaining path segment (`api/v1/observations`) to the path in `proxy_pass`, which is `/`. The upstream request becomes:

`http://127.0.0.1:51000/api/v1/observations`

This matches the backend’s existing `/api/v1/...` structure without changing application code.

The more generic `location /` block proxies all other requests (for example `/`, `/static/...`, etc.) to the Next.js web container on `127.0.0.1:51001`.

## Environment variables

Find environment variable guide in [Deployment Guide](deployment.md).

## Certificates and Certbot

Certbot is installed on the VM and manages Let’s Encrypt certificates for the domains. Certificates are stored under `/etc/letsencrypt/live/<name>/`.

The list of certs can be viewed with:

```bash
sudo certbot certificates
```

For beta, there is an entry:

```text
Certificate Name: beta.lumisovellus.fi
  Domains: beta.lumisovellus.fi
  Certificate Path: /etc/letsencrypt/live/beta.lumisovellus.fi/fullchain.pem
  Private Key Path: /etc/letsencrypt/live/beta.lumisovellus.fi/privkey.pem
```

These paths are used in the Nginx beta server block:

```nginx
ssl_certificate /etc/letsencrypt/live/beta.lumisovellus.fi/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/beta.lumisovellus.fi/privkey.pem;
```

Certbot is usually run with the Nginx plugin to obtain and configure certificates, for example:

```bash
sudo certbot --nginx -d beta.lumisovellus.fi
```

This command both gets the certificate and injects ssl_certificate and related directives into the Nginx config. It also sets up auto-renewal via cron or a systemd timer, so normally no manual renewal is needed.

## Changing or inspecting Nginx configuration

All Nginx config changes should be followed by a config test and reload:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

The `-t` check must succeed (no “conflicting server name” warnings and no syntax errors) before reloading; otherwise Nginx will keep the previous working config.

The enabled sites are in `/etc/nginx/sites-enabled/`; these are symlinks to files in `/etc/nginx/sites-available/`. For beta, the enabled file is:

`/etc/nginx/sites-enabled/dev.lumisovellus.fi` -> `/etc/nginx/sites-available/dev.lumisovellus.fi`

If you ever add another environment (for example `staging.lumisovellus.fi`), the pattern is:

- Create an A record pointing to the VM.

- Create a new Nginx site file copying and adjusting the beta one (server_name, certificate name, perhaps ports/upstream services).

- Run Certbot with --nginx for the new domain.

- Test and reload Nginx.
