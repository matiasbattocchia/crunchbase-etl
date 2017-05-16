CREATE TABLE IF NOT EXISTS crunchbase_people (
  first_name varchar,
  last_name varchar,
  country_code char(3),
  state_code varchar,
  city varchar,
  cb_url varchar,
  logo_url varchar,
  profile_image_url varchar,
  twitter_url varchar,
  facebook_url varchar,
  primary_affiliation_organization varchar,
  primary_affiliation_title varchar,
  primary_organization_uuid uuid REFERENCES crunchbase_organizations,
  gender varchar,
  uuid uuid PRIMARY KEY,
  created_at timestamp,
  updated_at timestamp
);

CREATE TEMP TABLE crunchbase_people_temp (LIKE crunchbase_people);

\COPY crunchbase_people_temp FROM 'people.csv' WITH CSV HEADER;

INSERT INTO crunchbase_people
SELECT p.* FROM crunchbase_people_temp AS p
JOIN crunchbase_organizations AS o
  ON o.uuid = p.primary_organization_uuid;
