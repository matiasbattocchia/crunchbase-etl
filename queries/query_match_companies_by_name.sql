SELECT s.id, s.name, c.uuid, c.company_name
FROM (
        SELECT  s.id, s.name
        FROM    companies AS s
        LEFT JOIN crunchbase_salesforce_organizations AS o
                ON s.id = o.salesforce_company_id
        WHERE o.salesforce_company_id IS NULL
                AND s.deleted IS FALSE
) AS s
JOIN (
        SELECT DISTINCT ON (lower(company_name)) uuid, company_name
        FROM   crunchbase_organizations
        ORDER  BY lower(company_name), updated_at DESC
) AS c
        ON lower(s.name) = lower(c.company_name);