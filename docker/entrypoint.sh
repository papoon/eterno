#!/bin/sh
set -e

APP_DIR=/var/www/html
TMP_DIR=/tmp/laravel-temp

cd "$APP_DIR"

if [ ! -f "$APP_DIR/artisan" ]; then
  echo "No Laravel app detected in $APP_DIR — creating project using Composer..."

  # Create a temporary directory and generate the project there so we don't conflict with scaffold files
  rm -rf "$TMP_DIR"
  mkdir -p "$TMP_DIR"

  composer create-project laravel/laravel "$TMP_DIR" --prefer-dist --no-interaction || {
    echo "Composer create-project failed in $TMP_DIR" >&2
    exit 1
  }

  # Rsync the generated Laravel app into APP_DIR but preserve scaffold files (Docker, docker-compose, README, docker folder)
  # Exclude these known scaffold files so they are not overwritten
  rsync -a --no-perms --omit-dir-times \
    --exclude 'docker/' \
    --exclude 'Dockerfile' \
    --exclude 'docker-compose.yml' \
    --exclude 'README.md' \
    --exclude '.env.example' \
    "$TMP_DIR/" "$APP_DIR/"

  chown -R www-data:www-data "$APP_DIR" || true
  rm -rf "$TMP_DIR"
fi

# Install vendors (in case composer.lock exists) — run in APP_DIR
cd "$APP_DIR"
composer install --no-interaction || true

# If there's a frontend project, install deps and build so Vite manifest is generated
if [ -f package.json ]; then
  echo "Found package.json — installing npm dependencies and building assets"
  # prefer npm ci when lockfile present, fall back to npm install; use legacy-peer-deps to avoid ERESOLVE issues
  if [ -f package-lock.json ]; then
    npm ci --legacy-peer-deps || npm install --legacy-peer-deps
  else
    npm install --legacy-peer-deps || true
  fi

  # Run the build to generate public/build/manifest.json
  npm run build --silent || true
fi

# Some Vite/plugin combinations place the manifest under public/build/.vite/manifest.json
# Ensure Laravel's expected manifest path exists by copying it into place if necessary
if [ -f public/build/.vite/manifest.json ] && [ ! -f public/build/manifest.json ]; then
  echo "Copying public/build/.vite/manifest.json -> public/build/manifest.json"
  cp public/build/.vite/manifest.json public/build/manifest.json || true
fi

# Copy .env.example to .env if none exists
if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
fi

# Generate app key if missing
if [ -f artisan ]; then
  php artisan key:generate --ansi || true
fi

echo "Starting Laravel development server on 0.0.0.0:8000"
php artisan serve --host=0.0.0.0 --port=8000
