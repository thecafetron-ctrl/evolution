# Railway Environment Variables for Evolution API

## Required Environment Variables

Set these in your Railway service settings:

### Server Configuration
```
SERVER_NAME=evolution
SERVER_TYPE=http
SERVER_PORT=$PORT
SERVER_URL=https://YOUR_RAILWAY_URL
SERVER_DISABLE_DOCS=false
SERVER_DISABLE_MANAGER=false
```

### Database (Neon PostgreSQL)
```
DATABASE_PROVIDER=postgresql
DATABASE_CONNECTION_URI=postgresql://neondb_owner:npg_Skx5X2MHsJfh@ep-royal-waterfall-af0b2gns-pooler.c-2.us-west-2.aws.neon.tech/neondb?channel_binding=require&sslmode=require
DATABASE_CONNECTION_CLIENT_NAME=evolution
DATABASE_SAVE_DATA_INSTANCE=true
DATABASE_SAVE_DATA_NEW_MESSAGE=true
DATABASE_SAVE_MESSAGE_UPDATE=true
DATABASE_SAVE_DATA_CONTACTS=true
DATABASE_SAVE_DATA_CHATS=true
DATABASE_SAVE_DATA_HISTORIC=true
DATABASE_SAVE_DATA_LABELS=true
DATABASE_SAVE_IS_ON_WHATSAPP=true
DATABASE_SAVE_IS_ON_WHATSAPP_DAYS=7
DATABASE_DELETE_MESSAGE=false
```

### Authentication
```
AUTHENTICATION_API_KEY=evo_api_key_secure_2026
AUTHENTICATION_EXPOSE_IN_FETCH_INSTANCES=false
```

### Redis (Optional - Use Railway Redis addon or disable)
```
CACHE_REDIS_ENABLED=false
CACHE_LOCAL_ENABLED=true
CACHE_LOCAL_TTL=86400
```

### CORS
```
CORS_ORIGIN=*
CORS_METHODS=POST,GET,PUT,DELETE
CORS_CREDENTIALS=true
```

### Logs
```
LOG_LEVEL=ERROR,WARN,INFO,LOG
LOG_COLOR=false
LOG_BAILEYS=error
```

### Other Settings
```
LANGUAGE=pt-BR
DEL_INSTANCE=false
DEL_TEMP_INSTANCES=true
QRCODE_LIMIT=30
QRCODE_COLOR=#198754
WEBSOCKET_ENABLED=true
WEBSOCKET_GLOBAL_EVENTS=true
TELEMETRY_ENABLED=false
EVENT_EMITTER_MAX_LISTENERS=50
```

## Deployment Steps

1. **Create a new Railway project** or use your existing one

2. **Add Evolution API as a new service:**
   - Go to your Railway project
   - Click "New Service" → "GitHub Repo"
   - Select your repository
   - Set the **Root Directory** to `evolution-api`

3. **Configure Environment Variables:**
   - Go to the service settings
   - Add all the environment variables listed above
   - Make sure to update `SERVER_URL` with your actual Railway URL after deployment

4. **Deploy:**
   - Railway will automatically build and deploy
   - The build command: `npm install && npm run db:generate && npm run build`
   - The start command: `npm run db:deploy && npm run start:prod`

## Important Notes

- Railway automatically provides `$PORT` variable
- Update `SERVER_URL` after first deployment with your actual Railway URL
- The database is already configured with Neon PostgreSQL
- Redis is disabled by default; enable if you add Railway Redis addon
