Words Projects
==============

Create a new DB where you are administrator, then load the environment ``.
./dev.env``, and deploy the schema with::
    sqitch deploy

Backup::
    pg_dump --data-only --format plain -f db_dump.sql words


