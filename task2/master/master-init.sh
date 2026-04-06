echo "host replication all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'replicatorpass';
ALTER SYSTEM SET wal_level = 'replica';
ALTER SYSTEM SET max_wal_senders = 10;
ALTER SYSTEM SET wal_keep_size = 1024;
ALTER SYSTEM SET hot_standby = on;
EOSQL

pg_ctl restart