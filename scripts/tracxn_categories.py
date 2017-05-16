import psycopg2
import psycopg2.extras
import json

conn = psycopg2.connect(dbname='',
                        user='',
                        password='',
                        host='')

conn.set_session(autocommit=True)


def insert_category(parent_id, long_name, short_name):
    cur = conn.cursor()

    insert_query = """ INSERT INTO tracxn_categories
                       (parent_id, long_name, short_name)
                       VALUES (NULLIF(%d, 0), '%s', '%s')
                       RETURNING id;
                   """ % (parent_id, long_name, short_name)

    cur.execute(insert_query)
    category_id = cur.fetchone()[0]
    cur.close()

    return category_id


def get_category_id(feed):
    cur = conn.cursor()

    long_name = feed.replace("'", "''")

    query = """ SELECT id FROM tracxn_categories
                WHERE long_name = '%s'
                LIMIT 1;
            """ % long_name

    cur.execute(query)
    category = cur.fetchone()
    cur.close()

    if category: return category[0]

    feed_list  = long_name.split(' > ')
    short_name = feed_list[-1]

    if len(feed_list) > 1:
        parent_feed = ' > '.join(feed_list[0:-1])
        parent_id   = get_category_id(parent_feed)
    else:
        parent_id   = 0

    category_id = insert_category(parent_id, long_name, short_name)

    return category_id


####

def insert_company_category(company_uuid, category_id):
    insert_query = """ INSERT INTO tracxn_categories_crunchbase_organizations
                       (company_uuid, category_id) VALUES ('%s', %d);
                   """ % (company_uuid, category_id)

    cur.execute(insert_query)


cur = conn.cursor()

query = """ SELECT uuid, company_name, data->>'feeds' AS feeds
            FROM crunchbase_organizations
            JOIN tracxn_companies ON uuid = company_uuid
            WHERE data->'feeds' IS NOT NULL;
        """

cur.execute(query)
orgs = cur.fetchall()
cur.close()

companies = str(len(orgs))
print('Processing ' + companies + ' companies...', '----')

cur = conn.cursor()

for index, org in enumerate(orgs):
    company_uuid = org[0]
    company_name = org[1]
    feeds = json.loads(org[2])

    for feed in feeds:
        category_id = get_category_id(feed)
        insert_company_category(company_uuid, category_id)

    print(str(index + 1) + '/' + companies + ' ' + company_name)

print('----', 'DONE')

cur.close()
conn.close()
