#!/bin/bash
set -e

# Step 1: Get the container ID
CONTAINER_ID=$(docker ps --filter "name=girma_backend" --format "{{.ID}}")

if [ -z "$CONTAINER_ID" ]; then
  echo "❌ No container found with name containing 'girma_backend'"
  exit 1
fi

# Step 2: Copy backup files to container
echo "📂 Copying backup files..."
docker cp ./backup/* "$CONTAINER_ID":/home/frappe/frappe-bench/sites/frontend/private/backups/

# Step 3: Restore database and files
echo "🔄 Restoring backup inside container..."
docker exec -it "$CONTAINER_ID" bash -c "
cd /home/frappe/frappe-bench &&
bench --site frontend --force restore ./sites/frontend/private/backups/20250905_121648-frontend-database.sql.gz \
  --with-public-files ./sites/frontend/private/backups/20250905_121648-frontend-files.tar \
  --with-private-files ./sites/frontend/private/backups/20250905_121648-frontend-private-files.tar
"

# Step 4: Run migrate
echo "📦 Running bench migrate..."
docker exec -it "$CONTAINER_ID" bash -c "
cd /home/frappe/frappe-bench &&
bench --site frontend migrate
"

# Step 5: Enable server scripts
echo "⚙️ Enabling server scripts..."
docker exec -it "$CONTAINER_ID" bash -c "
cd /home/frappe/frappe-bench &&
bench set-config -g server_script_enabled 1
"

echo "✅ Restore and setup completed successfully!"
echo "Open the Browser through port in Codespace"
