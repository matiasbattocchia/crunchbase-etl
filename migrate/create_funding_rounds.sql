CREATE TABLE IF NOT EXISTS crunchbase_funding_rounds (
  company_name varchar,
  country_code char(3),
  state_code char(2),
  region varchar,
  city varchar,
  company_category_list varchar,
  funding_round_type varchar,
  funding_round_code varchar,
  announced_on date,
  raised_amount_usd bigint,
  raised_amount bigint,
  raised_amount_currency_code char(3),
  target_money_raised_usd bigint,
  target_money_raised bigint,
  target_money_raised_currency_code char(3),
  post_money_valuation_usd bigint,
  post_money_valuation bigint,
  post_money_currency_code char(3),
  investor_count smallint,
  investor_names varchar,
  cb_url varchar,
  company_uuid uuid REFERENCES crunchbase_organizations,
  funding_round_uuid uuid PRIMARY KEY,
  created_at timestamp,
  updated_at timestamp
);

CREATE TEMP TABLE crunchbase_funding_rounds_temp (LIKE crunchbase_funding_rounds);

\COPY crunchbase_funding_rounds_temp FROM 'funding_rounds.csv' WITH CSV HEADER;

INSERT INTO crunchbase_funding_rounds
SELECT f.* FROM crunchbase_funding_rounds_temp AS f
JOIN crunchbase_organizations AS o
  ON o.uuid = f.company_uuid;
