CREATE TABLE IF NOT EXISTS tracxn_categories(
  id smallserial PRIMARY KEY,
  parent_id  smallint REFERENCES tracxn_categories,
  long_name  varchar NOT NULL,
  short_name varchar NOT NULL
);

CREATE TABLE IF NOT EXISTS tracxn_categories_crunchbase_organizations(
  company_uuid uuid     REFERENCES crunchbase_organizations,
  category_id  smallint REFERENCES tracxn_categories,
  UNIQUE (company_uuid, category_id)
);
