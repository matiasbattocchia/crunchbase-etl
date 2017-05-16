SELECT domain FROM crunchbase_organizations as c
JOIN deal_sourcing_scores as d ON c.uuid = d.company_uuid

LEFT OUTER JOIN tracxn_companies as t ON c.uuid = t.company_uuid

WHERE domain IS NOT NULL;