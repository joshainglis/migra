-- Test case: Adding a primary key to a partitioned table
-- The migration should NOT use "USING INDEX" syntax because partitioned indexes are not valid

CREATE TABLE events (
    sequence_id     bigint not null,
    ingested_at     timestamptz not null,
    payload         jsonb not null,
    PRIMARY KEY (sequence_id, ingested_at)
) PARTITION BY RANGE (ingested_at);

CREATE TABLE events_default PARTITION OF events DEFAULT;

CREATE TABLE events_2024_01 PARTITION OF events
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');
