CREATE TABLE IF NOT EXISTS crunchbase_funds (
  entity_uuid uuid,
  fund_uuid uuid PRIMARY KEY,
  fund_name varchar,
  started_on date,
  announced_on date,
  raised_amount bigint,
  raised_amount_currency_code char(3),
  created_at timestamp,
  updated_at timestamp
);

\COPY crunchbase_funds FROM 'funds.csv' WITH CSV HEADER;
