#!/bin/bash
# Railway startup script - v4

echo ">>>>> RAILWAY STARTUP SCRIPT RUNNING <<<<<"
echo ">>>>> PORT=$PORT <<<<<"
echo ">>>>> DATABASE_PROVIDER=$DATABASE_PROVIDER <<<<<"

# Export SERVER_PORT for the app to use  
export SERVER_PORT="${PORT:-8080}"
export DATABASE_URL="$DATABASE_CONNECTION_URI"

echo ">>>>> SERVER_PORT=$SERVER_PORT <<<<<"

# Create .env file
cat > .env << EOF
DATABASE_PROVIDER=${DATABASE_PROVIDER:-postgresql}
DATABASE_CONNECTION_URI=$DATABASE_CONNECTION_URI
SERVER_TYPE=http
SERVER_PORT=$SERVER_PORT
AUTHENTICATION_API_KEY=${AUTHENTICATION_API_KEY:-test}
CACHE_REDIS_ENABLED=false
CACHE_LOCAL_ENABLED=true
CORS_ORIGIN=*
LANGUAGE=en
EOF

echo ">>>>> .env created <<<<<"

echo ">>>>> Running migrations <<<<<"
npm run db:deploy || echo ">>>>> Migration failed! <<<<<"

echo ">>>>> Starting app on port $SERVER_PORT <<<<<"
exec node dist/main.js
