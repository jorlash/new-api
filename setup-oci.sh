#!/bin/bash
set -e
cd /opt/router-hub

# Generate secrets
PG_PASS=$(openssl rand -hex 16)
REDIS_PASS=$(openssl rand -hex 16)
SESS=$(openssl rand -hex 32)
CRYPT=$(openssl rand -hex 32)

# Create .env
cat > .env << EOF
POSTGRES_USER=rhub
POSTGRES_PASSWORD=${PG_PASS}
POSTGRES_DB=router_hub
REDIS_PASSWORD=${REDIS_PASS}
SQL_DSN=postgresql://rhub:${PG_PASS}@postgres:5432/router_hub
REDIS_CONN_STRING=redis://:${REDIS_PASS}@redis:6379
SESSION_SECRET=${SESS}
CRYPTO_SECRET=${CRYPT}
TZ=Asia/Shanghai
ERROR_LOG_ENABLED=true
BATCH_UPDATE_ENABLED=true
NODE_NAME=router-hub-node-1
EOF

echo ".env created with generated secrets"

# Create docker-compose.yml
cat > docker-compose.yml << 'COMPOSEOF'
version: "3.4"

services:
  router-hub:
    build: .
    container_name: router-hub
    restart: always
    command: --log-dir /app/logs
    ports:
      - "127.0.0.1:3001:3000"
    volumes:
      - ./data:/data
      - ./logs:/app/logs
    env_file:
      - .env
    depends_on:
      - redis
      - postgres
    networks:
      - router-hub-network
    healthcheck:
      test: ["CMD-SHELL", "wget -q -O - http://localhost:3000/api/status | grep -o '\"success\":\\s*true' || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3

  redis:
    image: redis:alpine
    container_name: router-hub-redis
    restart: always
    command: ["redis-server", "--requirepass", "${REDIS_PASSWORD}"]
    env_file:
      - .env
    networks:
      - router-hub-network

  postgres:
    image: postgres:15-alpine
    container_name: router-hub-postgres
    restart: always
    env_file:
      - .env
    volumes:
      - pg_data:/var/lib/postgresql/data
    networks:
      - router-hub-network

volumes:
  pg_data:

networks:
  router-hub-network:
    driver: bridge
COMPOSEOF

echo "docker-compose.yml created"
echo "Ready to build and start"
