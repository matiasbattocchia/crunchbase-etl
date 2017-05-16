CREATE TABLE IF NOT EXISTS crunchbase_investments (
  funding_round_uuid uuid REFERENCES crunchbase_funding_rounds,
  investor_uuid uuid REFERENCES crunchbase_investors,
  is_lead_investor boolean,
  UNIQUE (funding_round_uuid, investor_uuid)
);

CREATE TEMP TABLE crunchbase_investments_temp (LIKE crunchbase_investments);

\COPY crunchbase_investments_temp FROM 'investments.csv' WITH CSV HEADER;

INSERT INTO crunchbase_investments
SELECT DISTINCT ON (funding_round_uuid, investor_uuid) i.*
FROM crunchbase_investments_temp AS i
JOIN crunchbase_funding_rounds AS funding_rounds
  ON funding_rounds.funding_round_uuid = i.funding_round_uuid
JOIN crunchbase_investors AS investors
  ON investors.uuid = i.investor_uuid;

-- after selecting distinct (funding round, investor) records,
-- the investor_count column at crunchbase_funding_rounds table
-- should be updated as there are not repeated investors anymore
UPDATE crunchbase_funding_rounds AS f
SET    investor_count = i.investor_count
FROM (
  SELECT funding_round_uuid, count(investor_uuid) AS investor_count
  FROM   crunchbase_investments
  GROUP BY funding_round_uuid
  ) AS i
WHERE f.funding_round_uuid = i.funding_round_uuid;
