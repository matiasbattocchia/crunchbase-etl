CREATE TABLE IF NOT EXISTS crunchbase_investors (
  investor_name varchar,
  primary_role varchar,
  domain varchar,
  country_code char(3),
  state_code char(2),
  region varchar,
  city varchar,
  investor_type varchar,
  investment_count smallint,
  total_funding_usd bigint,
  founded_on date,
  closed_on date,
  cb_url varchar,
  logo_url varchar,
  profile_image_url varchar,
  twitter_url varchar,
  facebook_url varchar,
  uuid uuid PRIMARY KEY,
  updated_at timestamp
);

\COPY crunchbase_investors FROM 'investors.csv' WITH CSV HEADER;
