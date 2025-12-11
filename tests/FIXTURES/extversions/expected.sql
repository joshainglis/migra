COMMENT ON EXTENSION hstore IS NULL;

create extension if not exists "citext" with schema "public" version '1.5';

alter extension "pg_trgm" update to '1.4';

drop extension if exists "hstore";

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';
