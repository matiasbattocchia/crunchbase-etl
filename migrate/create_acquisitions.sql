CREATE TABLE IF NOT EXISTS crunchbase_acquisitions (
  acquiree_name varchar,
  acquiree_country_code char(3),
  state_code char(2),
  acquiree_region varchar,
  acquiree_city varchar,
  acquirer_name varchar,
  acquirer_country_code char(3),
  acquirer_state_code char(2),
  acquirer_region varchar,
  acquirer_city varchar,
  acquisition_type varchar,
  acquired_on date,
  price_usd bigint,
  price bigint,
  price_currency_code char(3),
  acquiree_cb_url varchar,
  acquirer_cb_url varchar,
  acquiree_uuid uuid REFERENCES crunchbase_organizations,
  acquirer_uuid uuid REFERENCES crunchbase_organizations,
  acquisition_uuid uuid PRIMARY KEY,
  created_at timestamp,
  updated_at timestamp
);

CREATE TEMP TABLE crunchbase_acquisitions_temp (LIKE crunchbase_acquisitions);

\COPY crunchbase_acquisitions_temp FROM 'acquisitions.csv' WITH CSV HEADER;

INSERT INTO crunchbase_acquisitions
SELECT a.* FROM crunchbase_acquisitions_temp AS a
JOIN crunchbase_organizations AS acquiree
  ON acquiree.uuid = a.acquiree_uuid
JOIN crunchbase_organizations AS acquirer
  ON acquirer.uuid = a.acquirer_uuid;
