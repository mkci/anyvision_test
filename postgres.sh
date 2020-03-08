#!/bin/bash

if [[ ! -e backups ]]; then
    mkdir backups
fi

docker run --name postgres_test -e POSTGRES_PASSWORD=test -d postgres

until docker exec -it postgres_test pg_isready > /dev/null 2>&1 ; do
	echo "Waiting for postgres server to be up"
	sleep 1
done

docker exec -i postgres_test psql -U postgres << EOF

CREATE DATABASE "anyVision";

\connect anyVision;

CREATE TABLE test(
   ID serial PRIMARY KEY,
   username VARCHAR (50) UNIQUE NOT NULL,
   password VARCHAR (50) NOT NULL
);

INSERT INTO test (username, password) 
VALUES
  ('test1', 'pass1'),
  ('test2', 'pass2');

EOF

docker exec -i postgres_test pg_dump -U postgres -F t anyVision | gzip >backups/backup_$(date +%Y%m%d_%H%M%S).tar.gz

rm -rf `ls -t backups/backup*.tar.gz | awk 'NR>10'`

rsync -av --delete backups/ /tmp/backups

docker stop postgres_test ; docker rm postgres_test
