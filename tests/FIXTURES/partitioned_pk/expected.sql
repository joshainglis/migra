alter table "public"."events" drop column "old_column";

select 1; -- CREATE UNIQUE INDEX events_2024_01_pkey ON public.events_2024_01 USING btree (sequence_id, ingested_at);

select 1; -- CREATE UNIQUE INDEX events_default_pkey ON public.events_default USING btree (sequence_id, ingested_at);

select 1; -- CREATE UNIQUE INDEX events_pkey ON ONLY public.events USING btree (sequence_id, ingested_at);

alter table "public"."events" add constraint "events_pkey" PRIMARY KEY (sequence_id, ingested_at);

select 1; -- alter table "public"."events_2024_01" add constraint "events_2024_01_pkey" PRIMARY KEY using index "events_2024_01_pkey";

select 1; -- alter table "public"."events_default" add constraint "events_default_pkey" PRIMARY KEY using index "events_default_pkey";
