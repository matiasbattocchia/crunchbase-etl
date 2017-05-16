SELECT *
FROM crunchbase_organizations
WHERE uuid IN (
        SELECT unnest(dup.uuid)
        FROM (
                SELECT array_agg(uuid) AS uuid
                FROM crunchbase_organizations
                GROUP BY lower(company_name) 
                HAVING ( count(*) > 1 )
        ) AS dup
) AND primary_role = 'company'