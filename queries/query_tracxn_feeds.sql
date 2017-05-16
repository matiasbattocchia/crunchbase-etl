SELECT uuid, company_name, data->>'feeds' AS feeds
FROM crunchbase_organizations
JOIN tracxn_companies ON uuid = company_uuid
WHERE data->'feeds' IS NOT NULL;
