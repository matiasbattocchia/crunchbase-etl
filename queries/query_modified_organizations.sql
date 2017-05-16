SELECT * FROM crunchbase_organizations
WHERE  updated_at > (
  -- it is the last Crunchbase date corresponding to
  -- the penultimate ETL load date
  SELECT last_crunchbase_updated_at
  FROM   etl_dates
  WHERE  etl_run_at = (
    SELECT max(etl_run_at)
    FROM   etl_dates
    WHERE  etl_run_at < (
      SELECT max(etl_run_at)
      FROM   etl_dates
    )
  )
);
