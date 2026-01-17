#!/bin/bash
# Railway startup script - v5

echo ">>>>> RAILWAY STARTUP SCRIPT RUNNING <<<<<"
echo ">>>>> PORT=$PORT <<<<<"
echo ">>>>> DATABASE_PROVIDER=$DATABASE_PROVIDER <<<<<"

# Export SERVER_PORT for the app to use  
export SERVER_PORT="${PORT:-8080}"
export DATABASE_URL="$DATABASE_CONNECTION_URI"

echo ">>>>> SERVER_PORT=$SERVER_PORT <<<<<"

# Create .env file with all required variables
cat > .env << EOF
DATABASE_PROVIDER=${DATABASE_PROVIDER:-postgresql}
DATABASE_CONNECTION_URI=$DATABASE_CONNECTION_URI
DATABASE_SAVE_DATA_INSTANCE=true
DATABASE_SAVE_DATA_NEW_MESSAGE=true
DATABASE_SAVE_MESSAGE_UPDATE=true
DATABASE_SAVE_DATA_CONTACTS=true
DATABASE_SAVE_DATA_CHATS=true
SERVER_TYPE=http
SERVER_PORT=$SERVER_PORT
AUTHENTICATION_API_KEY=${AUTHENTICATION_API_KEY:-evo_api_key_secure_2026}
CACHE_REDIS_ENABLED=false
CACHE_LOCAL_ENABLED=true
CORS_ORIGIN=*
CORS_METHODS=POST,GET,PUT,DELETE
CORS_CREDENTIALS=true
LANGUAGE=en
LOG_LEVEL=ERROR,WARN,INFO,LOG
LOG_COLOR=false
TELEMETRY_ENABLED=false
EOF

echo ">>>>> .env created <<<<<"

echo ">>>>> Running migrations <<<<<"
npm run db:deploy || echo ">>>>> Migration failed! <<<<<"

echo ">>>>> Starting app on port $SERVER_PORT <<<<<"
exec node dist/main.js
