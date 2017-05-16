CREATE TABLE IF NOT EXISTS crunchbase_ipos (
  name varchar,
  country_code char(3),
  company_state_code char(2),
  region varchar,
  city varchar,
  stock_exchange_symbol varchar,
  stock_symbol varchar,
  went_public_on date,
  price_usd bigint,
  price bigint,
  price_currency_code char(3),
  cb_url varchar,
  ipo_uuid uuid PRIMARY KEY,
  company_uuid uuid REFERENCES crunchbase_organizations,
  uuid uuid,
  created_at timestamp,
  updated_at timestamp
);

CREATE TEMP TABLE crunchbase_ipos_temp (LIKE crunchbase_ipos);

\COPY crunchbase_ipos_temp FROM 'ipos.csv' WITH CSV HEADER;

INSERT INTO crunchbase_ipos
SELECT i.* FROM crunchbase_ipos_temp AS i
JOIN crunchbase_organizations AS o
  ON o.uuid = i.company_uuid;
