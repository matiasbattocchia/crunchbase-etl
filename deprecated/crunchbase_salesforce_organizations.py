import psycopg2
import re

conn = psycopg2.connect(dbname='',
                        user='',
                        password='',
                        host='')

conn.set_session(autocommit=True)

# Clean the target table.
cur = conn.cursor()
cur.execute('DELETE FROM test_crunchbase_salesforce_organizations;')
cur.close()

# Bring all Salesforce companies.
cur = conn.cursor()
cur.execute('SELECT sfd_company_id, name, website FROM companies;')
salesforce_orgs = cur.fetchall()
cur.close()

# Bring all Salesforce companies.
#cur = conn.cursor()
#cur.execute('SELECT uuid, company_name, domain FROM crunchbase_organizations;')
#salesforce_orgs = cur.fetchall()
#cur.close()

companies = str(len(salesforce_orgs))

print('Matching ' + companies + ' companies...', '----')

def match_organization(name, tld):
    name = name.replace("'", "''").lower()
    cor = conn.cursor()

    if tld:

        query  = """ SELECT uuid, company_name, domain
                     FROM crunchbase_organizations
                     WHERE LOWER(domain) = '%s'
                        OR LOWER(company_name) = '%s'
                     LIMIT 1;
                 """ % (tld.lower(), name)
    else:

        query = """ SELECT uuid, company_name, domain
                    FROM crunchbase_organizations
                    WHERE LOWER(company_name) = '%s'
                    LIMIT 1;
                """ % name

    # Query the database and obtain data as Python objects.
    cor.execute(query)
    org = cor.fetchone()
    cor.close()

    return org


def insert_organization(salesforce_id, crunchbase_id):
    insert_query = """ INSERT INTO crunchbase_salesforce_organizations(
                         salesforce_company_id,
                         crunchbase_company_uuid)
                       VALUES ('%s', '%s');
                   """ % (salesforce_id, crunchbase_id)

    cur.execute(insert_query)


pattern = re.compile(r"^(?:https?:\/\/)?(?:www.)?(?P<tld>.*?\.[^/]*)")
cur = conn.cursor()

for index, org in enumerate(salesforce_orgs):
    sf_id = org[0]
    name  = org[1]
    url   = org[2]
    tld   = None

    if url:
        m = pattern.match(url)
        if m: tld = m.group('tld')

    match = match_organization(name, tld)

    if match:
        insert_organization(sf_id, match[0])
        print(str(index) + '/' + companies + ' ' + name + ' MATCHED')
    else:
        print(str(index) + '/' + companies + ' ' + name + ' FAILED')

print('----', 'DONE')

cur.close()
conn.close()
