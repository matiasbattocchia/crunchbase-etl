import psycopg2
import psycopg2.extras
import urllib.request
import json

def query_tracxn(domain):
    url     = "http://tracxn.com/api/1.0/company?domains=%s" % domain
    headers = {'accessToken': TRACXN_AUTH_TOKEN}
    req     = urllib.request.Request(url, None, headers)
    resp    = urllib.request.urlopen(req)
    code    = resp.getcode()

    if   code == 200:
        data = json.loads(resp.read().decode('utf-8'))

        if len(data['result']) != 0:
            return data['result'][0]
        else:
            return None

    elif code == 400:
        print('Bad request. The syntax of your query is wrong.')
    elif code == 401:
        print('Authorization issue. You are not authorized.')
    elif code == 900:
        print('Exceed limit. You have exceeded the monthly query limit.')
    elif code == 500:
        print('Server error. Something went wrong with Tracxn servers.')
    else:
        print('Unknown error code: %s.' % code)

    raise


# Connect to an existing database.
conn = psycopg2.connect(dbname='',
                        user='',
                        password='',
                        host='')

conn.set_session(autocommit=True)

cur = conn.cursor()

query = """ SELECT uuid, company_name, domain FROM crunchbase_organizations as c
            JOIN deal_sourcing_scores as d ON c.uuid = d.company_uuid
            LEFT OUTER JOIN tracxn_companies as t ON c.uuid = t.company_uuid
            WHERE domain IS NOT NULL;
        """

cur.execute(query)
orgs = cur.fetchall()
cur.close()

companies = str(len(orgs))
print('Querying ' + companies + ' companies...', '----')


def insert_organization(uuid, data):
    insert_query = """ INSERT INTO tracxn_companies(company_uuid, data)
                       VALUES ('%s', %s);
                   """ % (uuid, psycopg2.extras.Json(data))

    cur.execute(insert_query)


cur = conn.cursor()

for index, org in enumerate(orgs):
    uuid   = org[0]
    name   = org[1]
    domain = org[2]

    data = query_tracxn(domain)

    insert_organization(uuid, data)

    if data:
        print(str(index + 1) + '/' + companies + ' ' + name + ' FOUND')
    else:
        print(str(index + 1) + '/' + companies + ' ' + name + ' NOT found')

print('----', 'DONE')

# Close communication with the database.
cur.close()
conn.close()
