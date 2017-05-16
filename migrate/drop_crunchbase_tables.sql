DROP TABLE IF EXISTS
  -- crunchbase_salesforce_organizations,

  -- References crunchbase_funding_rounds and crunchbase_investors
  crunchbase_investments,

  -- Reference crunchbase_organizations
  deal_sourcing_scores,
  crunchbase_people,
  crunchbase_acquisitions,
  crunchbase_ipos,
  crunchbase_funding_rounds,

  -- Do not reference anything
  crunchbase_investors,
  crunchbase_funds,
  crunchbase_organizations;
