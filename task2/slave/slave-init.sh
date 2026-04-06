#!/bin/bash
set -e

echo "Waiting for master..."
until pg_isready -h master_db -p 5432; do
  sleep 2
done

echo "Cleaning data directory..."
rm -rf /var/lib/postgresql/data/*

echo "Running base backup..."
PGPASSWORD=replicatorpass pg_basebackup \
  -h master_db \
  -p 5432 \
  -U replicator \
  -D /var/lib/postgresql/data \
  -Fp -Xs -P -R

echo "Fixing permissions..."
chown -R postgres:postgres /var/lib/postgresql/data
chmod 700 /var/lib/postgresql/data

echo "Starting PostgreSQL..."
exec gosu postgres postgres