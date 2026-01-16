#!/bin/bash
# Railway startup script - v3
set -e

echo "=== Evolution API Railway Startup ==="
echo "Railway PORT: $PORT"

# Export SERVER_PORT for the app to use
export SERVER_PORT="${PORT:-8080}"
export DATABASE_URL="$DATABASE_CONNECTION_URI"

echo "Using SERVER_PORT: $SERVER_PORT"

# Create .env file with Railway environment variables
cat > .env << EOF
DATABASE_PROVIDER=${DATABASE_PROVIDER:-postgresql}
DATABASE_CONNECTION_URI=$DATABASE_CONNECTION_URI
SERVER_TYPE=http
SERVER_PORT=$SERVER_PORT
AUTHENTICATION_API_KEY=$AUTHENTICATION_API_KEY
CACHE_REDIS_ENABLED=${CACHE_REDIS_ENABLED:-false}
CACHE_LOCAL_ENABLED=${CACHE_LOCAL_ENABLED:-true}
CORS_ORIGIN=${CORS_ORIGIN:-*}
LANGUAGE=${LANGUAGE:-en}
LOG_LEVEL=DEBUG
EOF

echo "=== Running database migrations ==="
npm run db:deploy

echo "=== Starting Evolution API on port $SERVER_PORT ==="
exec npm run start:prod
