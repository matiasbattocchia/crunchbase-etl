CREATE TABLE IF NOT EXISTS tracxn_companies (
  company_uuid uuid UNIQUE REFERENCES crunchbase_organizations,
  data jsonb,
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now()
);
