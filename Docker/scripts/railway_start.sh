#!/bin/bash
# Railway startup script - v2
set -e

echo "=== Evolution API Railway Startup ==="
echo "PORT: ${PORT:-8080}"
echo "DATABASE_PROVIDER: $DATABASE_PROVIDER"

# Create .env file with Railway environment variables
cat > .env << EOF
DATABASE_PROVIDER=${DATABASE_PROVIDER:-postgresql}
DATABASE_CONNECTION_URI=$DATABASE_CONNECTION_URI
SERVER_TYPE=http
SERVER_PORT=${PORT:-8080}
AUTHENTICATION_API_KEY=$AUTHENTICATION_API_KEY
CACHE_REDIS_ENABLED=${CACHE_REDIS_ENABLED:-false}
CACHE_LOCAL_ENABLED=${CACHE_LOCAL_ENABLED:-true}
CORS_ORIGIN=${CORS_ORIGIN:-*}
LANGUAGE=${LANGUAGE:-en}
EOF

echo "=== .env file created ==="
cat .env

# Set DATABASE_URL for Prisma
export DATABASE_URL="$DATABASE_CONNECTION_URI"

echo "=== Running database migrations ==="
npm run db:deploy

echo "=== Starting Evolution API ==="
npm run start:prod
