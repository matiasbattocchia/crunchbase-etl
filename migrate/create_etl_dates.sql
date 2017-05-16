CREATE TABLE IF NOT EXISTS etl_dates (
  last_crunchbase_updated_at timestamp,
  etl_run_at timestamp
);

INSERT INTO etl_dates VALUES (
  (SELECT max(updated_at)
   FROM   crunchbase_organizations),
  now()
);
