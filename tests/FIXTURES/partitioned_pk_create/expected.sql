create table "public"."events" (
    "sequence_id" bigint not null,
    "ingested_at" timestamp with time zone not null,
    "payload" jsonb not null
) partition by RANGE (ingested_at);


create table "public"."events_2024_01" partition of "public"."events" FOR VALUES FROM ('2024-01-01 00:00:00+00') TO ('2024-02-01 00:00:00+00');


create table "public"."events_default" partition of "public"."events" DEFAULT;


drop type "public"."e";

select 1; -- CREATE UNIQUE INDEX events_2024_01_pkey ON public.events_2024_01 USING btree (sequence_id, ingested_at);

select 1; -- CREATE UNIQUE INDEX events_default_pkey ON public.events_default USING btree (sequence_id, ingested_at);

select 1; -- CREATE UNIQUE INDEX events_pkey ON ONLY public.events USING btree (sequence_id, ingested_at);

alter table "public"."events" add constraint "events_pkey" PRIMARY KEY (sequence_id, ingested_at);

select 1; -- alter table "public"."events_2024_01" add constraint "events_2024_01_pkey" PRIMARY KEY using index "events_2024_01_pkey";

select 1; -- alter table "public"."events_default" add constraint "events_default_pkey" PRIMARY KEY using index "events_default_pkey";
