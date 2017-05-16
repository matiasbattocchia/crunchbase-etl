CREATE TABLE IF NOT EXISTS deal_sourcing_scores (
  company_uuid uuid REFERENCES crunchbase_organizations,
  score real,
  raw_score real,
  model varchar,
  trained_at   timestamp,
  predicted_at timestamp
);

\COPY deal_sourcing_scores FROM 'deal_sourcing_scores.csv' WITH CSV HEADER;
