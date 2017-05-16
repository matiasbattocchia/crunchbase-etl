select c.uuid, c.company_name as name, o.stars as stars_old, n.stars as stars_new, o.score as score_old, n.score as score_new
--select count(*)
from
(select * from deal_sourcing_scores where model = '1.0.0') as n
join
(select * from deal_sourcing_scores where model = '0.0.0') as o
on n.uuid = o.uuid
join crunchbase_organizations as c
on uuid(o.uuid) = c.uuid
limit 5000